/*
  Warnings:

  - You are about to drop the column `FakeAnswerUserId` on the `Question` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `Question` DROP FOREIGN KEY `Question_FakeAnswerUserId_fkey`;

-- AlterTable
ALTER TABLE `Question` DROP COLUMN `FakeAnswerUserId`,
    ADD COLUMN `fakeAnswerUserId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_fakeAnswerUserId_fkey` FOREIGN KEY (`fakeAnswerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
