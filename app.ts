// ライブラリ読み込み
import express from "express";
import helmet from "helmet";
import cors from "cors";
import { Server, Socket } from "socket.io";
import { PrismaClient } from "@prisma/client";
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
  app.post("/user", (req, res) => {
    console.log(req.body);
    prisma.user.create({ data: JSON.parse(req.body) });
    res.send(201);
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
    process.exit(1);
  });
