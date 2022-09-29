// ライブラリ読み込み
import express from "express";
import helmet from "helmet";
import cors from "cors";
import { Server, Socket } from "socket.io";
import { PrismaClient, Role, User } from "@prisma/client";
import { v4 as uuidv4 } from "uuid";
import bodyParser from "body-parser";

const app = express();
app.use(helmet());
app.use(cors());

//body-parserの設定
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const prisma = new PrismaClient();

const port = process.env.PORT || 8000; // port番号を指定

async function main() {
  app.get("/", (_, res) => {
    res.send("server is up");
  });
  app.get("/user/:id", async (req, res) => {
    const user = await prisma.user.findUnique({
      where: { id: Number(req.params.id) },
    });
    res.status(200).send(user);
  });
  app.post("/user", async (req, res) => {
    if (!req.body.isOwner) {
      const user = await prisma.user.create({ data: req.body });
      res.status(201).send({ user });
      io.emit("joinMember", user.name);
      return;
    }
    const roomId = uuidv4();
    await prisma.room.create({
      data: { id: roomId, isPlaying: false, Round: 0 },
    });
    const user = await prisma.user.create({ data: { ...req.body, roomId } });
    res.status(201).send({ user });
  });
  app.put("/user/vote", async (req, res) => {
    const user = await prisma.user.update({
      data: req.body,
      where: { id: req.body.id },
    });
    const users = await prisma.user.findMany({
      where: { roomId: { equals: user.roomId } },
    });
    console.log(users);
    users.map((u) =>
      console.log(
        u.role === "REAL" ||
          u.role === "FAKE" ||
          u.isCorrectVote === true ||
          u.isCorrectVote === false
      )
    );
    if (
      users.every(
        (u) =>
          u.role === "REAL" ||
          u.role === "FAKE" ||
          u.isCorrectVote === true ||
          u.isCorrectVote === false
      )
    ) {
      console.log("allvote");
      io.emit("allVote", "allVote");
    }
    res.status(201).send();
  });
  app.get("/room/start-playng/:roomId", async (req, res) => {
    const users = await prisma.user.findMany({
      where: { roomId: { equals: req.params.roomId } },
    });
    users.sort(() => Math.round(Math.random()) - 1);
    users.map(async (u, i) => {
      let role: Role = "VOTER";
      switch (i) {
        case 0:
          role = "REAL";

          break;
        case 1:
          role = "FAKE";
          break;
        case 2:
        case 3:
        case 4:
          role = "Questioner";
      }
      await prisma.user.update({
        where: { id: u.id },
        data: { turnOrder: i, role },
      });
    });
    await prisma.room.update({
      data: { Real: Math.round(Math.random()) - 1 ? "A" : "B" },
      where: { id: req.params.roomId },
    });
    io.emit("start", "start");
    res.status(200).send("started");
  });
  app.get("/room", async (_, res) => {
    const rooms = await prisma.room.findMany();
    res.status(200).send(rooms);
  });
  app.get("/room/:roomId", async (req, res) => {
    const room = await prisma.room.findUnique({
      where: { id: req.params.roomId },
    });
    res.status(200).send(room);
  });
  app.get("/user/room/:roomId", async (req, res) => {
    const users = await prisma.user.findMany({
      where: { roomId: { equals: req.params.roomId } },
    });
    res.status(200).send(users);
  });
  app.get("/question/room/:roomId", async (req, res) => {
    const room = await prisma.room.findUnique({
      where: { id: req.params.roomId },
    });
    const roomWithQuestion = await prisma.room.findMany({
      where: { id: req.params.roomId },
      include: {
        User: { include: { AskedQuestion: { where: { Round: room?.Round } } } },
      },
    });
    const questions = roomWithQuestion
      .map((r) => r.User.map((u) => u.AskedQuestion))
      .flat()
      .flat();
    res.status(200).send(questions);
  });
  app.post("/question", async (req, res) => {
    await prisma.question.create({ data: req.body });
    io.emit("questionUpdated", "questionUpdated");
    res.status(201).send();
  });
  app.put("/question", async (req, res) => {
    await prisma.question.update({
      data: {
        realAnswerUserId: req.body.realAnswerUserId,
        realAnswer: req.body.realAnswer,
        fakeAnswerUserId: req.body.fakeAnswerUserId,
        fakeAnswer: req.body.fakeAnswer,
      },
      where: { id: req.body.id },
    });
    io.emit("questionUpdated", "questionUpdated");
    res.status(200).send();
  });
  app.get("/next-game/:roomId", async (req, res) => {
    const users = await prisma.user.findMany({
      where: { roomId: { equals: req.params.roomId } },
    });
    users.map(async (u, i) => {
      let role: Role = "VOTER";
      switch (i) {
        case 0:
          role = "REAL";

          break;
        case 1:
          role = "FAKE";
          break;
        case 2:
        case 3:
        case 4:
          role = "Questioner";
      }
      await prisma.user.update({
        where: { id: u.id },
        data: { turnOrder: i, role, isCorrectVote: null },
      });
    });
    await prisma.room.update({
      data: {
        Real: Math.round(Math.random()) - 1 ? "A" : "B",
        Round: { increment: 1 },
      },
      where: { id: req.params.roomId },
    });
    io.emit("next", "next");
    res.status(200).send("started");
  });

  //サーバ起動
  const server = app.listen(port);
  const io = new Server(server, {
    cors: { origin: "http://localhost:3000", credentials: true },
  });

  io.on("connection", (socket: Socket) => {
    console.log(`user connected ${socket.id}`);
  });
  console.log("listen on port " + port);
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    //process.exit(1);
  });
