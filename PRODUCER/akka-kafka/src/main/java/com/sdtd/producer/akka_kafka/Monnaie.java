package com.sdtd.producer.akka_kafka;
		
public class Monnaie {
			
			   String id;
			   String name;
			   String symbol;
			   String rank;
			  String  price_usd;
			  String price_btc;
			  String _24h_volume_usd;
			  String   market_cap_usd;
			  String  available_supply;
			  String  total_supply;
			  String  max_supply;
			  String  percent_change_1h;
			  String percent_change_24h;
			  String percent_change_7d;
			  String  last_updated;
		public void setId(String id) {
			this.id = id;
		}
		public void setName(String name) {
			this.name = name;
		}
		public void setSymbol(String symbol) {
			this.symbol = symbol;
		}
		public void setRank(String rank) {
			this.rank = rank;
		}
		public void setPrice_usd(String price_usd) {
			this.price_usd = price_usd;
		}
		public void setPrice_btc(String price_btc) {
			this.price_btc = price_btc;
		}
		public void set24h_volume_usd(String _24h_volume_usd) {
			this._24h_volume_usd = _24h_volume_usd;
		}
		public void setMarket_cap_usd(String market_cap_usd) {
			this.market_cap_usd = market_cap_usd;
		}
		public void setAvailable_supply(String available_supply) {
			this.available_supply = available_supply;
		}
		public void setTotal_supply(String total_supply) {
			this.total_supply = total_supply;
		}
		public void setMax_supply(String max_supply) {
			this.max_supply = max_supply;
		}
		public void setPercent_change_1h(String percent_change_1h) {
			this.percent_change_1h = percent_change_1h;
		}
		public String get24h_volume_usd() {
			return _24h_volume_usd;
		}
		public void set_24h_volume_usd(String _24h_volume_usd) {
			this._24h_volume_usd = _24h_volume_usd;
		}
		public String getId() {
			return id;
		}
		public String getName() {
			return name;
		}
		public String getSymbol() {
			return symbol;
		}
		public String getRank() {
			return rank;
		}
		public String getPrice_usd() {
			return price_usd;
		}
		public String getPrice_btc() {
			return price_btc;
		}
		public String getMarket_cap_usd() {
			return market_cap_usd;
		}
		public String getAvailable_supply() {
			return available_supply;
		}
		public String getTotal_supply() {
			return total_supply;
		}
		public String getMax_supply() {
			return max_supply;
		}
		public String getPercent_change_1h() {
			return percent_change_1h;
		}
		public String getPercent_change_24h() {
			return percent_change_24h;
		}
		public String getPercent_change_7d() {
			return percent_change_7d;
		}
		public String getLast_updated() {
			return last_updated;
		}
		public void setPercent_change_24h(String percent_change_24h) {
			this.percent_change_24h = percent_change_24h;
		}
		public void setPercent_change_7d(String percent_change_7d) {
			this.percent_change_7d = percent_change_7d;
		}
		public void setLast_updated(String last_updated) {
			this.last_updated = last_updated;
		}
		@Override
		public String toString() {
			return "Monnaie [id=" + id + ", name=" + name + ", symbol=" + symbol + ", rank=" + rank + ", price_usd=" + price_usd
					+ ", price_btc=" + price_btc + ", _24h_volume_usd=" + _24h_volume_usd + ", market_cap_usd=" + market_cap_usd
					+ ", available_supply=" + available_supply + ", total_supply=" + total_supply + ", max_supply=" + max_supply
					+ ", percent_change_1h=" + percent_change_1h + ", percent_change_24h=" + percent_change_24h
					+ ", percent_change_7d=" + percent_change_7d + ", last_updated=" + last_updated + "]\n";
		}
		  
		  
		}
