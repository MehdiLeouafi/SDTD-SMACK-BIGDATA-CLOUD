package com.sdtd.producer.akka_kafka;

public class SettingsImpl{

    public final String URI;
    public final String HOST;
    public final int PORT;
    

    public SettingsImpl() {
        URI =  "https://api.coinmarketcap.com/v1/";
        HOST = "https://api.coinmarketcap.com";
        PORT = 80;
        
    }

}
