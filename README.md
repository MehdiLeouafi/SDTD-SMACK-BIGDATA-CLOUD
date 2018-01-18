# Systemes-Distribues-pour-le-Traitement-de-Donnees-sur-le-cloud
---------REALISATION DU CAS D'UTILISATION 

---I   PRODUCER  

  1- Architecture du Producer  :

  2- Réalisation du Producer   :  
		

 	- Cette réalisation permet de recevoir ( en streaming ) les données des Cryptomonnaie, pratiquer un filtrage avant de passer les résultats
 	 à un Kafka broker. Cela se fait en plusieurs étapes :

 	 	#A- LA RECUPERATION D'UN JSON EN AKKA HTTP (Préciser le point ou pk AKKA HTTP est choisi) { Voir GUIDE/Akka]}
	 		* Un acteur de AKKA HTTP récupére un JSON à parti de l'URI suivant :  https://api.coinmarketcap.com/v1/ticker/ (la raison du choix s)
 	 	}

	 	#B- FILTRAGE Des données récupérées
		 		* Grace à Akka HTTP, nous pouvons récupérer Le flux de données ( JSON ) en Streaming, cela, nous permettra de pratiquer un 
		 				filtrage basé sur le classement du cryptomonnaie actuel afin de se concentrer que sur une partie
		 				 ( par exemple : les 20 cryptomonnaies les plus classés ) 
       	
       	#C- Publication des résultats sur un TOPIC D'un  broker KAFKA 
       			* Aprés avoir réalisé le filtrage, nous pouvons publier les résultats sur un ou plusieurs topics, lesquels nous sommes abonnés
       				sur un ou plusieurs broker KAFKA


  3- LANCEMENT DU JOB de Producer  :

  	* Ce job prend 4 paramétres qui sont : 
	 		A- Broker KAFKA     : l'URL du Kafka Broker
	 		B- TOPIC CHOISI     : L'ensemble des topics choisis 
	 		C- BORNE MINIMAL  : Le classement minimal du cryptomonnaie
	 		D- BORNE MAXIMAL  : Le classement maximal du cryptomonnaie
	 		E- NOMBRE REQUETE par minute : C'est le nombre de JSON à récupérer par minute (cela permet de controler la vitesse de requetage )

  	* Example pour lancer le JOB : 	

			#java -jar NOM_JOB_PRODUCER --broker:@IP_BROKER:PORT --topic:NOMTOPIC --min:BORNE_MINIMAL --max:BORNE_MAXIMAL --speed:NOMBRE_REQUETE_PAR_MINUTE


---II    CONSUMER 

	1- L'Architecture du Consumer 

	2- Rélisation de Consumer : 

		@.... VOIR DONC AMINE 

	3- LANCEMENT DU JOB DE CONSUMER : 

	* Ce job prend 3 paramétres qui sont : 
		  A- Broker KAFKA      : L'URL du kafka Broker ou de la listes des kafka Broker
		  B- TOPIC CHOISI      : L'ensemble des topics choisis
		  C- L'URL du Cassandra: L'URL de Cassandra

    * Example pour lancer le JOB : 	

	  	   #java -jar NOM_JOB_CONSUMER :@IP_BROKER:PORT NOMTOPIC @IP_CASSANDRA 



---III  L'automatisation du cas d'utilisation  

   1- Introduction 

 L'idée principal est de pouvoir réaliser l'ensemble des tâches requises pour le lancement du cas d'utilisation en un seul clique, tout 
 	en respectant l'architecture préalablement déployée par terraform et ansible. ( Figure Architecture Global Bastillon )


  2- Architecture de l'automatisation 

	 #-L'architecture suivante montre l'ensemble des machines requises et aussi le sénario mis en oeuvre  pour 
	 	réaliser cette automatisation :

  3- REALISATION ET Sénario de l'automatisation

	Le sénario de l'automatisation du cas d'utilisation se fait à travers deux étapes :

		1--Récupération des fichiers d'entrées :
		 	* La récupération d'un fichier HOSTS (par terraform) qui contient les adresses IP des différentes machines attribués à leurs roles.
		 		Example :

		 			(Image_FICHIER_HOSTS)

		 	* La récupération des clés ssh utilisé pour accéder à la machine bastian "deploy_cle", aussi que la clé utilisé par la machine bastian pour 
		 	  accéder aux différentes autres machines "cluster_interconnection_cle".


	 	2--Le lancement automatique du cas d'utilisation par l'éxécution d'un seul script ( "sh Remote-UseCase.sh") qui permettra de :

	 		* Envoyer à la machine bastian le script "UseCase.sh" sur lequel, il ya les différentes taches à éxécuter, et le paramétrage personalisé
	 		 ( Nombre de répliaction, nom de topic, La vitesse de requetage ...) 
	 		* Envoyer à la machine bastian le fichier HOSTS
	 		* Envoyer à la machine bastian la clé "cluster_interconnection_cle".
	 		* Envoyer à la machine bastian le lien pour accéder au JOB PRODUCER
	 		* Envoyer à la machine bastian le lien pour accéder au JOB CONSUMER
	 		* Exécuter le script "UseCase.sh" sur la machine bastian.

	 		Le script à éxécuté sur la machine Bastian "UseCase.sh" permettra automatiquement de :

	 			1- L'éxtraction de l'ensemble des adresses Ip, chacun représente une machine sur laquel est installé un service précis
	 			2- La création du Topic sur un ou plusieurs broker Kafka, tout en précisant un ensemble de paramétres ( Zookeper IP, La facteur de réplication, Le nom du Topic)	
	 			3- Lancement du JOB PRODUCER sur une machine qui a le role producer, cela se fait aprés que cette machine récupérera
	 			   l'ensemble des paramétres par la machine bastian :
	 			   	 -URI JOB PRODUCER : Lien permettant de télécharger le JOB PRODUCER EN LIGNE
	 			   	 -L'ENSEMBLE DES PARAMETRE PERMETTANT DE LANCER CE JOB ( Voir la partie "LANCEMENT DU JOB de Producer" )
	 			4- Lancement du JOB Consumer sur une machine sur laquel tourne le service Spark Driver ( sur notre cas, une machine avec 
	 				le role d'un Mesos MASTER, puisqu'elle contient les deux services : Mesos Master, Spark Driver) aussi cela se fait aprés avoir
	 				récupérées l''ensemble des paramétres par la machine bastian:
	 				 -URI permettant de télécharger le consumer (ou carrement, comme sur notre cas, la récéption du job préalablement recu par la machine bastian
	 				 -L'ENSEMBLE DES PARAMETRE PERMETTANT DE LANCER CE JOB ( Voir la partie "LANCEMENT DU JOB de Consumer" )






	
