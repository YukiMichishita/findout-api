/*
  Warnings:

  - You are about to drop the `AorB` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `Real` to the `Room` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `AorB` DROP FOREIGN KEY `AorB_userId_fkey`;

-- AlterTable
ALTER TABLE `Room` ADD COLUMN `Real` ENUM('A', 'B') NOT NULL;

-- DropTable
DROP TABLE `AorB`;
