-- AlterTable
ALTER TABLE `User` ADD COLUMN `role` ENUM('VOTER', 'REAL', 'FAKE', 'Questioner') NOT NULL DEFAULT 'VOTER';
