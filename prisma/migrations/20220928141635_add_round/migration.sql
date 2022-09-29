/*
  Warnings:

  - Added the required column `Round` to the `Question` table without a default value. This is not possible if the table is not empty.
  - Added the required column `Round` to the `Room` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Question` ADD COLUMN `Round` INTEGER NOT NULL;

-- AlterTable
ALTER TABLE `Room` ADD COLUMN `Round` INTEGER NOT NULL;
