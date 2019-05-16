package com.example.geoworkerv4.structures.Imported;

// import java.util.*;
import com.fasterxml.jackson.annotation.*;

public class Item {
    private String ruc;
    private String direccion;

    @JsonProperty("RUC")
    public String getRuc() { return ruc; }
    @JsonProperty("RUC")
    public void setRuc(String value) { this.ruc = value; }

    @JsonProperty("DIRECCION")
    public String getDireccion() { return direccion; }
    @JsonProperty("DIRECCION")
    public void setDireccion(String value) { this.direccion = value; }
}
