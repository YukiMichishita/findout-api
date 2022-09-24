/*
  Warnings:

  - You are about to drop the column `email` on the `User` table. All the data in the column will be lost.
  - You are about to drop the `Donees` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `isOwner` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX `User_email_key` ON `User`;

-- AlterTable
ALTER TABLE `User` DROP COLUMN `email`,
    ADD COLUMN `isOwner` BOOLEAN NOT NULL;

-- DropTable
DROP TABLE `Donees`;
