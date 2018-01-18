package com.sdtd.producer.akka_kafka;

import akka.NotUsed;
import akka.actor.ActorSystem;
import akka.http.javadsl.marshallers.jackson.Jackson;
import akka.stream.ActorMaterializer;
import akka.util.ByteString;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.util.Arrays;
import java.util.Optional;
import java.util.Properties;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

public class ClientApp {

	public static int count;
	
	
    public static void main(String[] args){
    	
    	final String NOM_BROKER = args[0].split(":")[1]+':'+args[0].split(":")[2];
    	final String NOM_TOPIC = args[1].split(":")[1];
    	final int MINIMAL_RANK = Integer.parseInt(args[2].split(":")[1]) ;
    	final int MAX_RANK     = Integer.parseInt(args[3].split(":")[1]) ;
    	final Integer NOMBRE_REQUETE_MIN = Integer.parseInt(args[4].split(":")[1]) ;
    	final long TIME_TO_SLEEP = (60l * 1000l) / NOMBRE_REQUETE_MIN.longValue() ;
    	
    	// Création d'un acteur
        ActorSystem actorSystem_1 = ActorSystem.create("client_1");

        AkkaHttpJavaClient client_1 = new AkkaHttpJavaClient(actorSystem_1, ActorMaterializer.create(actorSystem_1));

        
        //Configuration Kafka Producer
        Properties props = new Properties();
		 props.put("bootstrap.servers", NOM_BROKER);
		 props.put("acks", "all");
		 props.put("retries", 0);
		 props.put("batch.size", 30000);
		 props.put("linger.ms", 1);
		 props.put("buffer.memory", 33554432);
		 props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		 props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
		 
    	 Producer<String, String> producer = new KafkaProducer<>(props);
         System.out.println("\n\n --------------------------------   DEBUT PRODUCER  --------------------------------");

    	 while(true)
    	 {
    		 
	        client_1.requestLevelFutureBased(Optional.of("ticker/"), success ->
	        Jackson.unmarshaller(Monnaie[].class)
	               .unmarshall(success.entity(),
	            		   	client_1.getSystem().dispatcher(),
	            		   	client_1.getMaterializer())
	               )
	        	   .thenAccept(RDD ->  {
	        	 ObjectMapper objectMapper = new ObjectMapper();
	         	 objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
	           	 String json ="";
				try {
					Monnaie[] filtered =  Arrays.stream(RDD).
							filter(p -> Integer.parseInt(p.getRank()) >= MINIMAL_RANK && Integer.parseInt(p.getRank()) <= MAX_RANK)
							.toArray(Monnaie[]::new);
					
					json = objectMapper.writeValueAsString(filtered);
					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				ProducerRecord<String, String> P = new ProducerRecord<String, String>(NOM_TOPIC,json);
	           	 producer.send(P);
	           	 System.out.println("TRANSFERT TERMINE : OK");
	           	 })  
	            .whenComplete((success, throwable) ->{  System.out.println("TRANSFERT D'UNE REQUETE : EN COURS ");}
	           	 );
	        
			try {
				Thread.sleep(TIME_TO_SLEEP);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

    	 }
        	
    }
}