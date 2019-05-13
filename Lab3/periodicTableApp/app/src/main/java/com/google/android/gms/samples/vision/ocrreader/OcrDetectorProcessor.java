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

import android.util.Log;
import android.util.SparseArray;

import com.google.android.gms.samples.vision.ocrreader.ui.camera.GraphicOverlay;
import com.google.android.gms.vision.Detector;
import com.google.android.gms.vision.text.TextBlock;

import java.util.ArrayList;

/**
 * A very simple Processor which gets detected TextBlocks and adds them to the overlay
 * as OcrGraphics.
 */
public class OcrDetectorProcessor implements Detector.Processor<TextBlock> {

    private GraphicOverlay<OcrGraphic> graphicOverlay;
    private ArrayList<String> elements = new ArrayList<>();

    OcrDetectorProcessor(GraphicOverlay<OcrGraphic> ocrGraphicOverlay) {
        graphicOverlay = ocrGraphicOverlay;
        String[] elementsArray = {"H","Li","Na","K","Rb","Cs","Fr","Be","Mg","Ca","Sr","Ba","Ra",
                "Sc","Y","La-Lu","Ac Lr","Ti","Zr","Hf","Rf","V","Nb","Ta","Db","Cr","Mo","W","Sg",
                "Mn","Tc","Re","Bh","Fe","Ru","Os","Hs","Co","Rh","Ir","Mt","Ni","Pd","Pt","Ds","Cu",
                "Ag","Au","Rg","Zn","Cd","Hg","Cn","B","Al","Ga","In","Tl","C","Si","Ge","Sn","Pb",
                "Fl","N","P","As","Sb","Bi","Uup","O","S","Se","Te","Po","Lv","F","Cl","Br","I",
                "At","Uus","He","Ne","Ar","Kr","Xe","Rn","Uuo","La","Ac","Ce","Th","Pr","Pa","Nd",
                "U","Pm","Np","Sm","Pu","Eu","Am","Gd","Cm","Tb","Bk","Dy","Cf","Ho","Es","Er","Fm",
                "Tm","Md","Yb","No","Lu","Lr"};
        for(String e : elementsArray){
            elements.add(e);
        }
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
                if(!elements.contains(item.getValue()))
                    continue;
                Log.d("OcrDetectorProcessor", "Text detected! " + item.getValue());
                OcrGraphic graphic = new OcrGraphic(graphicOverlay, item);
                graphicOverlay.add(graphic);
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
