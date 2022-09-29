/*
  Warnings:

  - You are about to drop the column `answer` on the `Question` table. All the data in the column will be lost.
  - You are about to drop the column `answerUserId` on the `Question` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `Question` DROP FOREIGN KEY `Question_answerUserId_fkey`;

-- AlterTable
ALTER TABLE `Question` DROP COLUMN `answer`,
    DROP COLUMN `answerUserId`,
    ADD COLUMN `FakeAnswerUserId` INTEGER NULL,
    ADD COLUMN `fakeAnswer` VARCHAR(191) NULL,
    ADD COLUMN `realAnswer` VARCHAR(191) NULL,
    ADD COLUMN `realAnswerUserId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_realAnswerUserId_fkey` FOREIGN KEY (`realAnswerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_FakeAnswerUserId_fkey` FOREIGN KEY (`FakeAnswerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
