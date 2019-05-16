package com.example.geoworkerv4.structures.Exported;

import java.util.*;
import com.fasterxml.jackson.annotation.*;

public class Item {
    private String ruc;
    private String direccion;
    private boolean exact;
    private long coincidences;
    private double x;
    private double y;
    private String reason;

    @JsonProperty("RUC")
    public String getRuc() { return ruc; }
    @JsonProperty("RUC")
    public void setRuc(String value) { this.ruc = value; }

    @JsonProperty("DIRECCION")
    public String getDireccion() { return direccion; }
    @JsonProperty("DIRECCION")
    public void setDireccion(String value) { this.direccion = value; }

    @JsonProperty("exact")
    public boolean getExact() { return exact; }
    @JsonProperty("exact")
    public void setExact(boolean value) { this.exact = value; }

    @JsonProperty("coincidences")
    public long getCoincidences() { return coincidences; }
    @JsonProperty("coincidences")
    public void setCoincidences(long value) { this.coincidences = value; }

    @JsonProperty("x")
    public double getX() { return x; }
    @JsonProperty("x")
    public void setX(double value) { this.x = value; }

    @JsonProperty("y")
    public double getY() { return y; }
    @JsonProperty("y")
    public void setY(double value) { this.y = value; }

    @JsonProperty("reason")
    public String getReason() { return reason; }
    @JsonProperty("reason")
    public void setReason(String value) { this.reason = value; }
}
