/*
 * Copyright (C) The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.google.android.gms.samples.vision.ocrreader;

import android.graphics.Color;
import android.util.Log;
import android.util.SparseArray;

import com.google.android.gms.samples.vision.ocrreader.ui.camera.GraphicOverlay;
import com.google.android.gms.vision.Detector;
import com.google.android.gms.vision.text.TextBlock;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * A very simple Processor which gets detected TextBlocks and adds them to the overlay
 * as OcrGraphics.
 */
public class OcrDetectorProcessor implements Detector.Processor<TextBlock> {

    private GraphicOverlay<OcrGraphic> graphicOverlay;
    private int ACTIVITY_MODE;
    private HashMap<String,ArrayList<String>> elements;

    OcrDetectorProcessor(GraphicOverlay<OcrGraphic> ocrGraphicOverlay, HashMap<String,ArrayList<String>> newElements, int mode) {
        graphicOverlay = ocrGraphicOverlay;
        elements = newElements;
        ACTIVITY_MODE = mode;
    }

    public String containsandGroup(String element){
        for(String key : elements.keySet()){
            ArrayList<String> group = elements.get(key);
            if(group.contains(element))
                return key;

        }
        return null;
    }

    public int getColorForGroup(String group){
        switch(group){
            case "Alcalinos":
                return Color.RED;
            case "Alcalinotérreos":
                //ORANGE
                return Color.rgb(255, 165, 0);
            case "Metales":
                return Color.YELLOW;
            case "Metaloides":
                return Color.BLUE;
            case "No Metales":
                //PURPLE
                return Color.rgb(160, 32, 240);
            case "Halógenos":
                return Color.MAGENTA;
            case "Latanidos":
                return Color.GREEN;
            case "Actínidos":
                return Color.GRAY;
            case "Gases Nobles":
                return Color.CYAN;
            default :
                return Color.WHITE;
        }
    }

    public void drawBoxElement(TextBlock item){
        int color = getColorForGroup(containsandGroup(item.getValue()));
        OcrGraphic graphic = new OcrGraphic(graphicOverlay, item, color);
        graphicOverlay.add(graphic);
    }

    /**
     * Called by the detector to deliver detection results.
     * If your application called for it, this could be a place to check for
     * equivalent detections by tracking TextBlocks that are similar in location and content from
     * previous frames, or reduce noise by eliminating TextBlocks that have not persisted through
     * multiple detections.
     */
    @Override
    public void receiveDetections(Detector.Detections<TextBlock> detections) {
        graphicOverlay.clear();
        SparseArray<TextBlock> items = detections.getDetectedItems();
        for (int i = 0; i < items.size(); ++i) {
            TextBlock item = items.valueAt(i);
            if (item != null && item.getValue() != null) {
                // Table mode
                if(ACTIVITY_MODE == 0 || ACTIVITY_MODE == 1){
                    // JUST TO RECOGNIZE PERIODIC TABLE ELEMENTS
                    if(containsandGroup(item.getValue())==null)
                        continue;
                    drawBoxElement(item);
                }
                Log.d("OcrDetectorProcessor", "Text detected! " + item.getValue());
            }
        }
    }

    /**
     * Frees the resources associated with this detection processor.
     */
    @Override
    public void release() {
        graphicOverlay.clear();
    }
}
