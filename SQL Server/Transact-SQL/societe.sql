CREATE DATABASE Societe
USE Societe

CREATE TABLE Mouvement(
numMvt varchar(30) PRIMARY KEY NOT NULL,
typeMvt varchar(30),
quantite float,
codProdFini varchar(30) FOREIGN KEY REFERENCES ProduitFini(codProdFini)
)

CREATE TABLE ProduitBruit(
codProdBruit varchar(30) PRIMARY KEY NOT NULL,
nomProdBruit varchar(30),
prixAchat float,
numFour varchar(30) FOREIGN KEY REFERENCES Fournisseur(numFour)
)

CREATE TABLE Fournisseur(
numFour varchar(30) PRIMARY KEY NOT NULL,
rsFour varchar(30),
adFour varchar(30),
nbrProdFournis int
)

CREATE TABLE ProduitFini(
codProdFini varchar(30) PRIMARY KEY NOT NULL,
nomProd varchar(30),
qteStocker float
)

CREATE TABLE Composition(
codProdFini varchar(30) FOREIGN KEY REFERENCES ProduitFini(codProdFini),
codProdBruit varchar(30) FOREIGN KEY REFERENCES ProduitBruit(codProdBruit),
qteUtilisee float,
PRIMARY KEY (codProdFini, codProdBruit)
)

/*
 * un trigger qui à l'ajout de produits bruts dans la table 'Produit Brut' met à jour le champ NbrProduitsfournis pour les fournisseurs concernés
 */

CREATE TRIGGER ajoutePB ON ProduitBruit AFTER INSERT
AS
BEGIN 
	DECLARE @numFour varchar(30) = (SELECT numFour FROM INSERTED)
	UPDATE Fournisseur SET nbrProdFournis = nbrProdFournis + 1 WHERE numFour = @numFour
END

/*
 * Un trigger Qui à la suppression de produits bruts dans la table 'Produit Brut' met à jour le champ NbrProduitsfournis 
 * pour les fournisseurs concernés 
 */

CREATE TRIGGER supprimePB ON ProduitBruit AFTER DELETE 
AS
BEGIN
	DECLARE @numFour varchar(30) = (SELECT numFour FROM DELETED)
	UPDATE Fournisseur SET nbrProdFournis = nbrProdFournis - 1 WHERE numFour = @numFour
END

/*
 * Un trigger qui à l'ajout de mouvements dans la table mouvement met à jour le stock
 */

CREATE TRIGGER ajouteMvt ON Mouvement AFTER INSERT 
AS 
BEGIN 
	DECLARE @codProdFini varchar(30) = (SELECT codProdFini FROM INSERTED), @qte float = (SELECT quantite FROM INSERTED)
	UPDATE ProduitFini  SET qteStocker = qteStocker - @qte WHERE  codProdFini = @codProdFini
END

/*
 * Un trigger qui à la suppression de mouvements dans la table mouvement met à jour le stock
 */

CREATE TRIGGER suprMvt ON Mouvement AFTER DELETE 
AS
BEGIN
	DECLARE @codProdFini varchar(30) = (SELECT codProdFini FROM DELETED), @qte float = (SELECT quantite FROM DELETED)
	UPDATE ProduitFini  SET qteStocker = qteStocker + @qte WHERE  codProdFini = @codProdFini
END

/*
 * Un trigger qui à la modification de mouvements dans la table mouvement met à jour le stock
 */

CREATE TRIGGER updateMvt ON Mouvement AFTER UPDATE 
AS
BEGIN
	DECLARE @codProdFini varchar(30) = (SELECT codProdFini FROM DELETED), @qte float = (SELECT quantite FROM DELETED)
	UPDATE ProduitFini  SET qteStocker = qteStocker + @qte WHERE codProdFini = @codProdFini
END



















