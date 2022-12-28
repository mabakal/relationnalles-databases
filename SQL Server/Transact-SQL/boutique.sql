CREATE database boutique
use boutique

CREATE TABLE Article(
numArt varchar(20) PRIMARY KEY NOT NULL,
desArt TEXT,
puArt float,
qteStocker float,
seuilMax float,
seuilMin float
)

create table Commande(
numCmd varchar(20) primary key not null,
datCmd date
)

CREATE TABLE Ligne_Commande(
numCmd varchar(20) foreign key references Commande(numCmd),
numArt varchar(20) foreign key references Article(numArt),
qteCmd float,
primary key (numCmd, numArt)
)


/* 1 Créer une procédure stockée nommée SP_Articles qui affiche la liste des articles avec pour chaque article le numéro et la désignation */

CREATE PROC sp_Articles AS
BEGIN
	SELECT numArt, desArt FROM Article
END

/* 2 Créer une procédure stockée qui calcule le nombre d'articles par commande */
CREATE PROC nombreArticleCmd AS
BEGIN
	SELECT numCmd, COUNT(*) AS nombreArticle FROM Ligne_Commande GROUP BY numCmd 
END

/* 3 Créer une procédure stockée nommée SP_ListeArticles qui affiche la liste des articles d'une commande dont le numéro est donné en paramètre */

CREATE PROC Liste_Article(@numCmd varchar(20)) AS 
BEGIN 
	SELECT desArt, desArt FROM Article r, Ligne_Commande l WHERE r.numArt = l.numArt AND l.numCmd = @numCmd
END 

/* 3 Créer une procédure stockée nommée SP_ComPeriode qui affiche la liste des commandes effectuées entre deux dates données en paramètre. */

CREATE PROC  cmd_ComPeriode(@date1 date, @date2 date) AS 
BEGIN 
	SELECT numCmd FROM Command WHERE datCmd BETWEEN @date1 AND @date2
END 

/* 4 Créer une procédure stockée nommée SP_EnregistrerLigneCom qui reçoit un numéro de commande, un numéro d'article et la quantité commandée :
	 Si l'article n'existe pas ou si la quantité demandée n'est pas disponible afficher un message d'erreur
	 Si la commande introduite en paramètre n'existe pas, la créer
	 Ajoute ensuite la ligne de commande et met le stock à jour
*/

CREATE PROC enregistrementLigneCmd(@numCmd varchar(20), @numArt varchar(20), @qteCmd float) AS 
BEGIN 
	IF NOT EXISTS (SELECT * FROM Article WHERE numArt = @numArt)
	BEGIN 
		PRINT 'erreur l article n existe pas'
	END
	ELSE 
	BEGIN 
		DECLARE @qte_ float = (SELECT qteStocker FROM Article WHERE numArt = @numArt)
		IF @qte_ < @qteCmd
		BEGIN 
			PRINT 'erreur quantite insuffisant'
		END
		
		ELSE 
		BEGIN 
			IF NOT EXISTS (SELECT * FROM Commande WHERE numCmd = @numCmd )
			BEGIN 
				INSERT INTO Commande Values(@numCmd, '2022-11-14')
				INSERT INTO Ligne_Commande values(@numCmd, @numArt, @qteCmd)
			END
		END
	END	
END

/* 5 Créer une procédure stockée nommée SP_NbrArtCom qui retourne le nombre d'articles d'une commande dont le numéro est donné en paramètre.*/

CREATE PROC nbreArtCmd(@numCmd varchar(20), @nombreArticle int) AS 
BEGIN
	set @nombreArticle = (select COUNT(*) AS nombre FROM Ligne_Commande WHERE numCmd = @numCmd)
END














