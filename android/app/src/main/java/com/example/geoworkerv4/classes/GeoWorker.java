package com.example.geoworkerv4.classes;

import com.example.geoworkerv4.structures.Imported.ImportedAddresses;
import com.example.geoworkerv4.structures.Imported.ImportConverter;

import com.example.geoworkerv4.structures.Exported.ExportConverter;
import com.example.geoworkerv4.structures.Exported.ExportedAddresses;

import android.content.Context;
import android.location.Address;
import android.location.Geocoder;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import static java.util.Locale.getDefault;

public class GeoWorker {
    ImportedAddresses importedAddresses;
    ExportedAddresses exportedAddresses;

    private int successfullyCompleted;
    private int completedWithErrors;
    private int notFound;
    private String identifier;

    private final Geocoder geoCoder;
    public GeoWorker (Context context, String input, String identifier) {
        geoCoder = new Geocoder(context, getDefault());

        importedAddresses = new ImportedAddresses();
        importedAddresses.setItems(new ArrayList<com.example.geoworkerv4.structures.Imported.Item>());

        exportedAddresses = new ExportedAddresses();
        exportedAddresses.setItems(new ArrayList<com.example.geoworkerv4.structures.Exported.Item>());

        try {
            importedAddresses = ImportConverter.fromJsonString(input);
        } catch (IOException ex) {
            System.out.println("ERROR IN GEOWORKER'S CONSTRUCTOR");
            System.out.println(ex.toString());
            importedAddresses = new ImportedAddresses();
        }

        this.successfullyCompleted = 0;
        this.completedWithErrors = 0;
        this.identifier = identifier;
    }

    String multiGeocode () {
        for (com.example.geoworkerv4.structures.Imported.Item item : this.importedAddresses.getItems()) {
            this.geoCode(item);
        }

        String result = "{}";
        try {
            result = ExportConverter.toJsonString(this.exportedAddresses);
        } catch (Exception ex) {
            System.out.println(this.identifier + " - ERROR IN Multigeocode");
            System.out.println(ex.toString());
        }

        return result;

    }

    public void geoCode (com.example.geoworkerv4.structures.Imported.Item importedItem) {
        com.example.geoworkerv4.structures.Exported.Item exportedItem = new com.example.geoworkerv4.structures.Exported.Item();
        exportedItem.setRuc(importedItem.getRuc());
        exportedItem.setDireccion(importedItem.getDireccion());

        try {
            List<Address> addressList = geoCoder.getFromLocationName(importedItem.getDireccion(), 10);

            if (addressList.size() == 0) {
                // Not found
                this.notFound++;

                exportedItem.setX(0.0);
                exportedItem.setY(0.0);
                exportedItem.setExact(false);
                exportedItem.setCoincidences(0);
                exportedItem.setReason("Address not found");
            }

            if (addressList.size() > 0) {
                // Found
                Address address = addressList.get(0);

                exportedItem.setX(address.getLongitude());
                exportedItem.setY(address.getLatitude());
                exportedItem.setExact(addressList.size() == 1); // Multiple match
                exportedItem.setCoincidences(addressList.size());
                exportedItem.setReason("");

                if (address.hasLatitude() && address.hasLongitude()) {
                    exportedItem.setX(address.getLongitude());
                    exportedItem.setY(address.getLatitude());
                } else {
                    exportedItem.setReason(this.identifier + " - Address found but latitude and longitude are not available");
                }

                this.exportedAddresses.getItems().add(exportedItem);
                this.successfullyCompleted++;
                //System.out.printf("%s - ADDING OK %d%n", this.identifier, this.successfullyCompleted);
            }
        } catch (IOException ex) {
            // Error
            this.completedWithErrors++;
            //System.out.printf("%s - geoCode Exception%n", this.identifier);
            //System.out.println(ex.toString());
            //System.out.printf("%s - ADDING WITH ERROR %d%n", this.identifier, this.completedWithErrors);
        }
    }

    public int getSuccessfullyCompleted() {
        return this.successfullyCompleted;
    }

    public int getCompletedWithErrors() {
        return this.completedWithErrors;
    }

    public int getNotFound() {
        return this.notFound;
    }
}
