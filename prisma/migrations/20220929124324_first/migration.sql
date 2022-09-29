-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `isOwner` BOOLEAN NOT NULL,
    `roomId` VARCHAR(191) NOT NULL,
    `role` ENUM('VOTER', 'REAL', 'FAKE', 'Questioner') NOT NULL DEFAULT 'VOTER',
    `turnOrder` INTEGER NOT NULL,
    `isCorrectVote` BOOLEAN NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Room` (
    `id` VARCHAR(191) NOT NULL,
    `isPlaying` BOOLEAN NOT NULL,
    `Round` INTEGER NOT NULL,
    `Real` ENUM('A', 'B') NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Question` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `Round` INTEGER NOT NULL,
    `askUserId` INTEGER NOT NULL,
    `realAnswerUserId` INTEGER NULL,
    `fakeAnswerUserId` INTEGER NULL,
    `content` VARCHAR(191) NOT NULL,
    `realAnswer` VARCHAR(191) NULL,
    `fakeAnswer` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_roomId_fkey` FOREIGN KEY (`roomId`) REFERENCES `Room`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_askUserId_fkey` FOREIGN KEY (`askUserId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_realAnswerUserId_fkey` FOREIGN KEY (`realAnswerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_fakeAnswerUserId_fkey` FOREIGN KEY (`fakeAnswerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
