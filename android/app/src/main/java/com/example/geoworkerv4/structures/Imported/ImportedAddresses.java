package com.example.geoworkerv4.structures.Imported;

//import java.util.;
import com.fasterxml.jackson.annotation.*;

import java.util.List;

public class ImportedAddresses {
    private boolean connected;
    private List<Item> items;

    @JsonProperty("connected")
    public boolean getConnected() { return connected; }
    @JsonProperty("connected")
    public void setConnected(boolean value) { this.connected = value; }

    @JsonProperty("items")
    public List<Item> getItems() { return items; }
    @JsonProperty("items")
    public void setItems(List<Item> value) { this.items = value; }
}
