/*************						Les fonctions 						************
 * 	les fonctions c'est un ensemble d'operation effectue sur une donnée d'entré afin de produire un resultat
 * 	En remarquant bien notre activité quotidienne, notre environnement,il est facile de remarqué que tout peux
 *  etre modelisé par une fonction quand on veux preparer un recette, il y a un ensemble d'ingredient agencé pour
 *  refaire sortir un plat, ou quand on investi sur un projet, cette somme est transformé pour produire une une 
 * benéfice ou pertes dependant de la maniére d'utilisation. Il existe plusieurs type de fonctions
 * -recoivent des entrés et produisent des sorties
 * - recoivent des entrés et ne produisent pas de sorties
 * - recoivent d'entrés et ne produisent qu'une sortie
 * 
 * Dans ce qui va suivre on va implementé les fonctions
 * 
 *
 */

CREATE DATABASE TPFonction;
use TPFonction;
CREATE table Client(
clientId varchar(12) primary key not null,
nom varchar(29) not null,
ville varchar(20)
);

CREATE table Produit(
prodId varchar(12) primary key not null,
designation varchar(20),
marque varchar(20),
prix float not null
);

create table Acheter(
clientId varchar(12)  not null,
prodId int not null,
date_ date,
qte int
foreign key (clientId)  REFERENCES Client(clientId),
FOREIGN key (prodId) REFERENCES Produit(prodId),
primary key (clientId, prodId)
);

insert into Client values
('Cl1', 'Mouhcine', 'Béni Mellal'), ('Cl2', 'Said', 'Oujda'), 
('Cl3', 'Yassine', 'Berkane'), ('Cl4', 'Radouan', 'Meknès'),
('Cl5', 'Mohamed', 'marrakech')

insert into Produit values
('P1', 'PS','HP', 30), ('P2', 'PC', 'Apple', 1500),
('P3', 'KB', 'HP', 35), ('P4', 'Tab', 'Apple', 1000)

insert into Acheter values
('Cl1', 'P1', '05/09/2020', 30), ('Cl1', 'P2','05/09/2020', 10), ('Cl2', 'P4', '04/10/2020', 5), ('Cl3', 'P2', '10/11/2020', 25)

/* Une fonction qui retourne le nombre de produit existant*/

create function nombreProduit() returns int as
begin
	return (select COUNT(*) from Produit)
end

print TPFonction.dbo.nombreProduit()

/* Une fonction qui retourne le nombre de client total */
create function nombreClient() returns int as
begin
	return (select COUNT(*) from Client)
end

print dbo.nombreClient()
/* Une fonction qui retourne le nombre de produit acheter par un client donnée */

create function produitPayeClient(@clientId varchar(13)) returns int as
begin 
	return (select COUNT(*) from Client C, Acheter A where C.clientId = Acheter.clientId AND C.clientId = @cleintIdI)
end 

/* Une fonction qui retourne les different marque de produit acheter par un client donnée */

create function marqueClient(@clientId varchar(12)) returns TABLE as 
begin
	select * from Produit P, Acheter A where C.prodId = Acheter.prodId AND P.clientId = @clientId
end 

SELECT * from dbo.marqueClient('Cl1')
/* Fonction qui retourn facture total cleint */

create function factureTotal(@clientId varchar(13)) return float AS 
BEGIN 
	select sum(prix*qte) from Produit P, Acheter A where P.prodId = A.prodId and A.clientId = @clientId
END 

/* fonction qui retourn les different personne avec leur factures */
create function cleintFacture return TABLE  as 
begin
	select nom, SUM(prix*qte) from Produit P, Acheter A, Client C where P.prodId = A.prodId and Acheter.clientId = C.clientId GROUP by nom
end
