CREATE DATABASE ProcedureStocker;
use ProcedureStocker;


CREATE TABLE Recettes(
numRec varchar(10) primary key not null,
nomRec varchar(30),
methodePreparation varchar(40),
tempsPreparation varchar(40)
)

CREATE TABLE Ingredient(
numIng varchar(20) primary key not null,
nomIng varchar(40),
PUIng float,
numFou varchar(20) FOREIGN KEY REFERENCES Fournisseur(numFou)
)

CREATE TABLE Composition_Recette(
numRec varchar(10) FOREIGN KEY REFERENCES Recettes(numRec),
numIng varchar(20) FOREIGN KEY REFERENCES Ingredient(numIng),
qteUtilise int,
PRIMARY KEY (numRec, numIng)
)

CREATE TABLE Fournisseur(
numFou varchar(20) PRIMARY KEY,
rsFour varchar(30),
adFour varchar(50)
)

/* 1
 * Une procedure sotcker qui affiche la liste des ingrédients avec pour chaque ingrédient le numéro,
le nom et la raison sociale du fournisseur */

CREATE PROC afficheListeIngre AS
BEGIN
	SELECT * FROM Ingredient i , Fournisseur f WHERE i.numFou = f.numFou 
END


/* 2
 * une procedure stocker qui  affiche pour chaque recette le nombre d'ingrédients et le prix de revienue */

CREATE PROC recetteIngr AS 
BEGIN 
	SELECT COUNT(*) AS nombreIngrdients, SUM(puIng*qteUtilise) FROM Composition_Recette cr ,
	Ingredient i WHERE cr.numIng = i.numIng GROUP BY cr.numRec  
END


/* 3
 * Qui affiche la liste des recettes qui se composent de plus de 10 ingrédients avec pour chaque recette le numéro et le nom */

CREATE PROC recetteComp AS 
BEGIN 
	SELECT t.numero, t.nom FROM (
		SELECT  numRec AS numero, nomRec AS nom, COUNT(*) AS nombre_ingredient FROM Recettes r, 
		Composition_Recette cr WHERE r.numRec = cr.numRec GROUP BY cr.numRec 
	 ) AS t WHERE  nombre_ingredient > 10 
END


/* 4
 *  Une procedure stocker qui reçoit un numéro de recette et qui retourne son nom */

CREATE PROC retourneNom(@numRec varchar(19), @nom varchar(20) OUT ) AS
BEGIN 
	SET @nom = (SELECT nomRec FROM Recettes r WHERE numRec = @numRec)
END

/* 5
 * Qui reçoit un numéro de recette. Si cette recette a au moins un ingrédient,
la procédure retourne son meilleur ingrédient (celui qui a le montant le
plus bas) sinon elle retourne "Aucun ingrédient associé" */

CREATE PROC recetteIngMeilleurs(@numRec varchar(20), @nomIng varchar(20) OUT ) AS 
BEGIN
	SET @nomIng = (
					SELECT r.nomIng  FROM (SELECT TOP 1  nomIng, qteUtilise*puIng as prix FROM Composition_Recette cr, Ingredient i 
				WHERE cr.numIng = i.numIng AND cr.numRec = @numRec) AS r
				)
	 
	IF NOT EXISTS (SELECT COUNT(*) AS count_ FROM Composition_Recette cr2 WHERE cr2.numRec = @numRec )
		SET @nomIng = 'Aucun Ingredient associé'	
END


/* 6
 *  Qui reçoit un numéro de recette et qui affiche la liste des ingrédients correspondant à cette recette avec pour chaque 
 * ingrédient le nom, la quantité utilisée et le montant
 */

CREATE PROC recetteIng(@numRec varchar(20)) AS 
BEGIN 
	SELECT nomIng, qteUtilise, qteUtilise*puIng AS montant FROM Composition_Recette cr , Ingredient i WHERE cr.numIng = i.numIng AND 
	numRec = @numRec
END 


/* 7
 * Qui reçoit un numéro de recette et qui affiche :
		 Son nom (Procédure PS_4)
		 La liste des ingrédients ( procédure PS_6) 
		 Son meilleur ingrédient (PS_5)
*/

CREATE PROC afficheRecInf(@numRec varchar(20))   AS 
BEGIN 
	PRINT dbo.retourneNom(@numRec)
	SELECT * FROM dbo.recetteIng(@numRec)
	PRINT dbo.recetteIngMeilleurs(@numRec)
END


/* 8
 * Qui reçoit un numéro de fournisseur vérifie si ce fournisseur existe. Si ce n'est pas le cas afficher 
 le message 'Aucun fournisseur ne porte ce numéro' Sinon vérifier, s'il existe des ingrédients fournis par 
 ce fournisseur si c'est le cas afficher la liste des ingrédients associées (numéro et nom) Sinon afficher un message
  'Ce fournisseur n'a aucun ingrédient associé. Il sera supprimé' et supprimer ce fournisseur
*/

CREATE PROC founisseurIngs(@numFou varchar(20)) AS 
BEGIN 
	IF EXISTS (SELECT adFour  FROM Fournisseur f WHERE f.numFou = @numFou)
	BEGIN 
		IF EXISTS (SELECT COUNT(*) AS ingFournis FROM Fournisseur f2, Ingredient i WHERE f2.numFou = i.numFou AND i.numFou = @numFou)
		BEGIN 
			SELECT numIng, nomIng FROM Fournisseur f2, Ingredient i WHERE f2.numFou = i.numFou AND i.numFou = @numFou
		END
		ELSE 
		BEGIN 
			PRINT 'Ce fournisseur n as fournis aucun ingredients il sera supprime';
			DELETE FROM Fournisseur WHERE numFou = @numFou
		END 
		
	END
	ELSE 
		PRINT 'Aucun fournisseur ne porte ce nom'
	
END

/* 9
 * 	Qui affiche pour chaque recette :
	Un message sous la forme : "Recette : (Nom de la recette), temps de
	préparation : (Temps)
	La liste des ingrédients avec pour chaque ingrédient le nom et la quantité
	Un message sous la forme : Sa méthode de préparation est : (Méthode)
	Si le prix de reviens pour la recette est inférieur à 50 Dh afficher le
	message 'Prix intéressant'.
 */


CREATE PROC recettesInfo AS
BEGIN
	DECLARE recette CURSOR FOR (SELECT * FROM Recettes )
	DECLARE @numRec varchar(20), @nomRec varchar(20), @method varchar(20), @temps varchar(20)
	OPEN recette
	FETCH NEXT FROM recette INTO @numRec, @nomRec, @method, @temps
	WHILE(@@fetch_status = 0)
	BEGIN
		PRINT 'Recettes:' + @nomRec + ' temps de preparation :' + CONVERT(varchar(10), @temps)
		SELECT * FROM dbo.recetteIng(@numRec)
		
		PRINT 'Methode de preparation:' + @method
		
		DECLARE @montant FLOAT
		SET @montant = (SELECT SUM(qteUtilise*puIng) FROM Composition_Recette cr,
					Ingredient i WHERE cr.numIng = i.numIng AND numRec = @numRec)
		IF @montant > 50
			PRINT 'Recette Interessant'
	END
	
END







