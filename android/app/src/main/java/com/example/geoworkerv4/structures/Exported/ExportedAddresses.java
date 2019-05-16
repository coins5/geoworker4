package com.example.geoworkerv4.structures.Exported;

import java.util.*;
import com.fasterxml.jackson.annotation.*;

public class ExportedAddresses {
    private List<Item> items;

    @JsonProperty("items")
    public List<Item> getItems() { return items; }
    @JsonProperty("items")
    public void setItems(List<Item> value) { this.items = value; }
}
