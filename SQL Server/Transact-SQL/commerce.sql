CREATE DATABASE commerce
USE commerce

CREATE TABLE Achat(
numAchat varchar(20) PRIMARY KEY NOT NULL,
refer varchar(29) FOREIGN KEY REFERENCES Produit(refer),
dateAchat date,
prixAchat float,
qteEntrees float
)

CREATE TABLE Produit(
refer varchar(29) PRIMARY KEY NOT NULL,
design varchar(30),
prix float,
qteStock float
)

CREATE TABLE Vente(
numVente varchar(20) PRIMARY KEY NOT NULL,
refer varchar(29) FOREIGN KEY REFERENCES Produit(refer),
dateVente date,
prixVente float,
qteSorties float
)

/* 1
 * Créer le trigger ajouterProduit qui permet d’ajouter la quantité entrée de la table Achat
 *  à la quantité en stock dans la table produit correspondant à chaque insertion d’un achat.
*/

CREATE TRIGGER ajouterProduit ON Achat AFTER INSERT 
AS 
BEGIN 
	DECLARE @refer varchar(20) = (SELECT refer FROM INSERTED), @qteEntree float = (SELECT qteEntrees FROM INSERTED)
		UPDATE Produit SET qteStock = qteStock + @qteEntree WHERE refer = @refer
END

/* 1
 * Créer le trigger T2 qui permet de retrancher la quantité sortie de la table Vente de la quantité en stock dans 
 * la table produit correspondant à chaque insertion d’une vente.
 */

CREATE TRIGGER retancherProduit ON Vente AFTER INSERT 
AS 
BEGIN 
	DECLARE @refer varchar(20) = (SELECT refer FROM INSERTED), @qteSorties float = (SELECT qteSorties FROM INSERTED)
		UPDATE Produit SET qteStock = qteStock - @qteSorties WHERE refer = @refer
END

/*3
 * Ecrire le trigger achatSupprimer dans la table Achat qui permet de mettre à jour la Qut_Stock de la table 
 * Produit après chaque suppression d’un achat.
 */

CREATE TRIGGER achatSupprimer ON Achat AFTER DELETE 
AS
BEGIN
	DECLARE @refer varchar(20) = (SELECT refer FROM DELETED), @qteEntrees float = (SELECT qteEntrees FROM DELETED)
		UPDATE Produit SET qteStock = qteStock - @qteEntrees WHERE refer = @refer
END

/*
 * Ecrire le trigger venteSupprimer dans la table Vente qui permet de mettre à jour la Qut_Stock de la table
 *  Produit après chaque suppression d’une Vente. 
 */

CREATE TRIGGER venteSupprimer ON Vente AFTER DELETE 
AS
BEGIN
	DECLARE @refer varchar(20) = (SELECT refer FROM DELETED), @qteSorties float = (SELECT qteSorties FROM DELETED)
		UPDATE Produit SET qteStock = qteStock + @qteSorties WHERE refer = @refer
END















