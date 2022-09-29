-- DropForeignKey
ALTER TABLE `Question` DROP FOREIGN KEY `Question_answerUserId_fkey`;

-- AlterTable
ALTER TABLE `Question` MODIFY `answerUserId` INTEGER NULL;

-- AddForeignKey
ALTER TABLE `Question` ADD CONSTRAINT `Question_answerUserId_fkey` FOREIGN KEY (`answerUserId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
