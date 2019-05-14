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

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.net.Uri;
import android.os.Bundle;
import android.speech.tts.TextToSpeech;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.samples.vision.ocrreader.ui.camera.CameraSource;
import com.google.android.gms.samples.vision.ocrreader.ui.camera.CameraSourcePreview;
import com.google.android.gms.samples.vision.ocrreader.ui.camera.GraphicOverlay;
import com.google.android.gms.samples.vision.ocrreader.ui.camera.MainActivity;
import com.google.android.gms.vision.text.TextBlock;
import com.google.android.gms.vision.text.TextRecognizer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Locale;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Activity for the Ocr Detecting app.  This app detects text and displays the value with the
 * rear facing camera. During detection overlay graphics are drawn to indicate the position,
 * size, and contents of each TextBlock.
 */
public final class OcrCaptureActivity extends AppCompatActivity {
    private static final String TAG = "OcrCaptureActivity";

    // Intent request code to handle updating play services if needed.
    private static final int RC_HANDLE_GMS = 9001;

    // Permission request codes need to be < 256
    private static final int RC_HANDLE_CAMERA_PERM = 2;

    // Constants used to pass extra data in the intent
    public static final String AutoFocus = "AutoFocus";
    public static final String UseFlash = "UseFlash";
    public static final String TextBlockObject = "String";

    private CameraSource cameraSource;
    private CameraSourcePreview preview;
    private GraphicOverlay<OcrGraphic> graphicOverlay;

    // Helper objects for detecting taps and pinches.
    private ScaleGestureDetector scaleGestureDetector;
    private GestureDetector gestureDetector;

    // A TextToSpeech engine for speaking a String value.
    private TextToSpeech tts;

    // HashMap of table elements
    private HashMap<String, ArrayList<String>> elements;

    // Random elements for memory
    private int numberOfElements = 3;
    private int correct = 0;
    private ArrayList<String> randElements;

    // Activity Mode
    /** 0 -> Modo TABLA PERIODICA 1 -> Modo VERIFICAR FORMULAS
    **/
    private int ACTIVITY_MODE;

    /**
     * Initializes the UI and creates the detector pipeline.
     */
    @Override
    public void onCreate(Bundle bundle) {
        super.onCreate(bundle);
        setContentView(R.layout.ocr_capture);

        // Set up the Text To Speech engine.
        TextToSpeech.OnInitListener listener =
                new TextToSpeech.OnInitListener() {
                    @Override
                    public void onInit(final int status) {
                        if (status == TextToSpeech.SUCCESS) {
                            Log.d("OnInitListener", "Text to speech engine started successfully.");
                            tts.setLanguage(new Locale("spa", "ES"));
                        } else {
                            Log.d("OnInitListener", "Error starting the text to speech engine.");
                        }
                    }
                };
        tts = new TextToSpeech(this.getApplicationContext(), listener);

        // Define table elements
        // Elements Classified
        String[] alacalinos = {"Li","Na","K","Rb","Cs","Fr"};
        String[] alcalinoterreos = {"Be","Mg","Ca","Sr","Ba","Ra","Sc","Y","Ti","Zr","Hf","Rf","V",
                "Nb","Ta","Db","Cr","Mo","W","Sg", "Mn","Tc","Re","Bh","Fe","Ru","Os","Hs","Co",
                "Rh","Ir","Mt","Ni","Pd","Pt","Ds","Cu","Ag","Au","Rg","Zn","Cd","Hg","Cn"};
        String[] metales = {"Al","Ga","In","Tl","Sn","Pb","Fl","Bi","Lv","Mc","Nh"};
        String[] metaloides = {"B","Si","Ge","As","Sb","Te","Po"};
        String[] nometales = {"H","C","N","O","P","S","Se"};
        String[] halogenos = {"F","Cl","Br","I","At","Ts"};
        String[] latanidos = {"La","Ce","Pr","Nd","Pm","Sm","Eu","Gd","Tb","Dy","Ho","Er","Tm","Yb","Lu"};
        String[] actinidos = {"Ac","Th","Pa", "U","Np","Pu","Am","Cm","Bk","Cf","Es","Fm","Md","No","Lr"};
        String[] gasesnobles = {"He","Ne","Ar","Kr","Xe","Rn","Og"};
        // Add elements to hash map
        elements = new HashMap<>();
        elements.put("Alcalinos", new ArrayList<>(Arrays.asList(alacalinos)));
        elements.put("Alcalinotérreos", new ArrayList<>(Arrays.asList(alcalinoterreos)));
        elements.put("Metales", new ArrayList<>(Arrays.asList(metales)));
        elements.put("Metaloides", new ArrayList<>(Arrays.asList(metaloides)));
        elements.put("No Metales", new ArrayList<>(Arrays.asList(nometales)));
        elements.put("Halógenos", new ArrayList<>(Arrays.asList(halogenos)));
        elements.put("Latanidos", new ArrayList<>(Arrays.asList(latanidos)));
        elements.put("Actínidos", new ArrayList<>(Arrays.asList(actinidos)));
        elements.put("Gases Nobles", new ArrayList<>(Arrays.asList(gasesnobles)));

        preview = (CameraSourcePreview) findViewById(R.id.preview);
        graphicOverlay = (GraphicOverlay<OcrGraphic>) findViewById(R.id.graphicOverlay);

        // GET ACTIVITY MODE
        Intent intent = getIntent();
        ACTIVITY_MODE = intent.getIntExtra("ACTIVITY_MODE",0);

        // IF IS MEMORY MODE
        if(ACTIVITY_MODE == 1){
            correct = 0;
            randElements = new ArrayList<>();
            for(int i = 0; i < numberOfElements; i++){
                Random r = new Random();
                int number = r.nextInt(9);
                randElements.add(getRandElement(number));
            }
        }

        // Set good defaults for capturing text.
        boolean autoFocus = true;
        boolean useFlash = false;

        // Check for the camera permission before accessing the camera.  If the
        // permission is not granted yet, request permission.
        int rc = ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA);
        if (rc == PackageManager.PERMISSION_GRANTED) {
            createCameraSource(autoFocus, useFlash);
        } else {
            requestCameraPermission();
        }

        gestureDetector = new GestureDetector(this, new CaptureGestureListener());
        scaleGestureDetector = new ScaleGestureDetector(this, new ScaleListener());

        Snackbar.make(graphicOverlay, "Tap to Speak. Pinch/Stretch to zoom",
                Snackbar.LENGTH_LONG)
                .show();
    }

    // Get random element for memory mode
    public String getRandElement(int number){
        String key = "";
        switch(number){
            case 0:
                key = "Alcalinos";
                break;
            case 1:
                key = "Alcalinotérreos";
                break;
            case 2:
                key = "Metales";
                break;
            case 3:
                key = "Metaloides";
                break;
            case 4:
                key = "No Metales";
                break;
            case 5:
                key = "Halógenos";
                break;
            case 6:
                key = "Latanidos";
                break;
            case 7:
                key = "Actínidos";
                break;
            case 8:
                key = "Gases Nobles";
                break;
        }
        ArrayList<String> elementsArray = elements.get(key);
        Random r = new Random();
        int indx = r.nextInt(elementsArray.size());
        return elementsArray.get(indx);
    }

    /**
     * Handles the requesting of the camera permission.  This includes
     * showing a "Snackbar" message of why the permission is needed then
     * sending the request.
     */
    private void requestCameraPermission() {
        Log.w(TAG, "Camera permission is not granted. Requesting permission");

        final String[] permissions = new String[]{Manifest.permission.CAMERA};

        if (!ActivityCompat.shouldShowRequestPermissionRationale(this,
                Manifest.permission.CAMERA)) {
            ActivityCompat.requestPermissions(this, permissions, RC_HANDLE_CAMERA_PERM);
            return;
        }

        final Activity thisActivity = this;

        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                ActivityCompat.requestPermissions(thisActivity, permissions,
                        RC_HANDLE_CAMERA_PERM);
            }
        };

        Snackbar.make(graphicOverlay, R.string.permission_camera_rationale,
                Snackbar.LENGTH_INDEFINITE)
                .setAction(R.string.ok, listener)
                .show();
    }

    @Override
    public boolean onTouchEvent(MotionEvent e) {
        boolean b = scaleGestureDetector.onTouchEvent(e);

        boolean c = gestureDetector.onTouchEvent(e);

        return b || c || super.onTouchEvent(e);
    }

    /**
     * Creates and starts the camera.  Note that this uses a higher resolution in comparison
     * to other detection examples to enable the ocr detector to detect small text samples
     * at long distances.
     *
     * Suppressing InlinedApi since there is a check that the minimum version is met before using
     * the constant.
     */
    @SuppressLint("InlinedApi")
    private void createCameraSource(boolean autoFocus, boolean useFlash) {
        Context context = getApplicationContext();

        // A text recognizer is created to find text.  An associated multi-processor instance
        // is set to receive the text recognition results, track the text, and maintain
        // graphics for each text block on screen.  The factory is used by the multi-processor to
        // create a separate tracker instance for each text block.
        TextRecognizer textRecognizer = new TextRecognizer.Builder(context).build();
        OcrDetectorProcessor detector = new OcrDetectorProcessor(graphicOverlay,elements,ACTIVITY_MODE);
        textRecognizer.setProcessor(detector);
        // IF IS MEMORY MODE
        if(ACTIVITY_MODE == 1){
            String sim = randElements.get(0);
            String el = getElementfromSymbol(sim);
            String question = "¿Que símbolo se corresponde con el elemento "+el+" ?";
            System.out.println("SPEAKING!");
            tts.speak(question,TextToSpeech.QUEUE_FLUSH,null);
        }

        if (!textRecognizer.isOperational()) {
            // Note: The first time that an app using a Vision API is installed on a
            // device, GMS will download a native libraries to the device in order to do detection.
            // Usually this completes before the app is run for the first time.  But if that
            // download has not yet completed, then the above call will not detect any text,
            // barcodes, or faces.
            //
            // isOperational() can be used to check if the required native libraries are currently
            // available.  The detectors will automatically become operational once the library
            // downloads complete on device.
            Log.w(TAG, "Detector dependencies are not yet available.");

            // Check for low storage.  If there is low storage, the native library will not be
            // downloaded, so detection will not become operational.
            IntentFilter lowstorageFilter = new IntentFilter(Intent.ACTION_DEVICE_STORAGE_LOW);
            boolean hasLowStorage = registerReceiver(null, lowstorageFilter) != null;

            if (hasLowStorage) {
                Toast.makeText(this, R.string.low_storage_error, Toast.LENGTH_LONG).show();
                Log.w(TAG, getString(R.string.low_storage_error));
            }
        }

        // Creates and starts the camera.  Note that this uses a higher resolution in comparison
        // to other detection examples to enable the text recognizer to detect small pieces of text.
        cameraSource =
                new CameraSource.Builder(getApplicationContext(), textRecognizer)
                .setFacing(CameraSource.CAMERA_FACING_BACK)
                .setRequestedPreviewSize(1280, 1024)
                .setRequestedFps(2.0f)
                .setFlashMode(useFlash ? Camera.Parameters.FLASH_MODE_TORCH : null)
                .setFocusMode(autoFocus ? Camera.Parameters.FOCUS_MODE_CONTINUOUS_VIDEO : null)
                .build();
    }

    @Override
    protected void onStart() {
        super.onStart();
        // IF IS MEMORY MODE
        if(ACTIVITY_MODE == 1){
            String sim = randElements.get(0);
            String el = getElementfromSymbol(sim);
            String question = "¿Que símbolo se corresponde con el elemento "+el+" ?";
            System.out.println("SPEAKING!");
            tts.speak(question,TextToSpeech.QUEUE_FLUSH,null);
        }
    }

    /**
     * Restarts the camera.
     */
    @Override
    protected void onResume() {
        super.onResume();
        startCameraSource();
        // IF IS MEMORY MODE
        if(ACTIVITY_MODE == 1){
            String sim = randElements.get(0);
            String el = getElementfromSymbol(sim);
            String question = "¿Que símbolo se corresponde con el elemento "+el+" ?";
            System.out.println("SPEAKING!");
            tts.speak(question,TextToSpeech.QUEUE_FLUSH,null);
        }
    }

    /**
     * Stops the camera.
     */
    @Override
    protected void onPause() {
        super.onPause();
        if (preview != null) {
            preview.stop();
        }
    }

    /**
     * Releases the resources associated with the camera source, the associated detectors, and the
     * rest of the processing pipeline.
     */
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (preview != null) {
            preview.release();
        }
    }

    /**
     * Callback for the result from requesting permissions. This method
     * is invoked for every call on {@link #requestPermissions(String[], int)}.
     * <p>
     * <strong>Note:</strong> It is possible that the permissions request interaction
     * with the user is interrupted. In this case you will receive empty permissions
     * and results arrays which should be treated as a cancellation.
     * </p>
     *
     * @param requestCode  The request code passed in {@link #requestPermissions(String[], int)}.
     * @param permissions  The requested permissions. Never null.
     * @param grantResults The grant results for the corresponding permissions
     *                     which is either {@link PackageManager#PERMISSION_GRANTED}
     *                     or {@link PackageManager#PERMISSION_DENIED}. Never null.
     * @see #requestPermissions(String[], int)
     */
    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode != RC_HANDLE_CAMERA_PERM) {
            Log.d(TAG, "Got unexpected permission result: " + requestCode);
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
            return;
        }

        if (grantResults.length != 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            Log.d(TAG, "Camera permission granted - initialize the camera source");
            // we have permission, so create the camerasource
            boolean autoFocus = getIntent().getBooleanExtra(AutoFocus,true);
            boolean useFlash = getIntent().getBooleanExtra(UseFlash, false);
            createCameraSource(autoFocus, useFlash);
            return;
        }

        Log.e(TAG, "Permission not granted: results len = " + grantResults.length +
                " Result code = " + (grantResults.length > 0 ? grantResults[0] : "(empty)"));

        DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                finish();
            }
        };

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Multitracker sample")
                .setMessage(R.string.no_camera_permission)
                .setPositiveButton(R.string.ok, listener)
                .show();
    }

    /**
     * Starts or restarts the camera source, if it exists.  If the camera source doesn"t exist yet
     * (e.g., because onResume was called before the camera source was created), this will be called
     * again when the camera source is created.
     */
    private void startCameraSource() throws SecurityException {
        // check that the device has play services available.
        int code = GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(
                getApplicationContext());
        if (code != ConnectionResult.SUCCESS) {
            Dialog dlg =
                    GoogleApiAvailability.getInstance().getErrorDialog(this, code, RC_HANDLE_GMS);
            dlg.show();
        }

        if (cameraSource != null) {
            try {
                preview.start(cameraSource, graphicOverlay);
            } catch (IOException e) {
                Log.e(TAG, "Unable to start camera source.", e);
                cameraSource.release();
                cameraSource = null;
            }
        }
    }

    private void search(String element){
        String url="https://es.wikipedia.org/wiki/Special:Search/"+element;
        Intent intent = new Intent(Intent.ACTION_VIEW).setData(Uri.parse(url));
        startActivity(intent);
    }

    public String containsandGroup(String element){
        for(String key : elements.keySet()){
            ArrayList<String> group = elements.get(key);
            if(group.contains(element))
                return key;
        }
        return null;
    }

    public String getElementfromSymbol(String recievedText){
        String element = "";

        switch (recievedText){
            case "H":
                element = "Hidrogeno";
                break;
            case "Li":
                element = "Litio";
                break;
            case "Na":
                element = "Sodio";
                break;
            case "K":
                element = "Potasio";
                break;
            case "Rb":
                element = "Rubidio";
                break;
            case "Cs":
                element = "Cesio";
                break;
            case "Fr":
                element = "Francio";
                break;
            case "Be":
                element = "Berilio";
                break;
            case "Mg":
                element = "Magnesio";
                break;
            case "Ca":
                element = "Calcio";
                break;
            case "Sr":
                element = "Estroncio";
                break;
            case "Ba":
                element = "Bario";
                break;
            case "Ra":
                element = "Radio";
                break;
            case "Sc":
                element = "Escandio";
                break;
            case "Y":
                element = "Ytrio";
                break;
            case "Ti":
                element = "Titanio";
                break;
            case "Zr":
                element = "Cironio";
                break;
            case "Hf":
                element = "Hafnio";
                break;
            case "Rf":
                element = "Rutherfordio";
                break;
            case "V":
                element = "Vanadio";
                break;
            case "Nb":
                element = "Niobio";
                break;
            case "Ta":
                element = "Tantalo";
                break;
            case "Db":
                element = "Dubnio";
                break;
            case "Cr":
                element = "Cromo";
                break;
            case "Mo":
                element = "Molibdeno";
                break;
            case "W":
                element = "Wolframio";
                break;
            case "Sg":
                element = "Seaborgio";
                break;
            case "Mn":
                element = "Manganeso";
                break;
            case "Tc":
                element = "Tecnecio";
                break;
            case "Re":
                element = "Renio";
                break;
            case "Bh":
                element = "Bohrio";
                break;
            case "Fe":
                element = "Hierro";
                break;
            case "Ru":
                element = "Rutenio";
                break;
            case "Os":
                element = "Osmio";
                break;
            case "Hs":
                element = "Hassio";
                break;
            case "Co":
                element = "Cobalto";
                break;
            case "Rh":
                element = "Rodio";
                break;
            case "Ir":
                element = "Iridio";
                break;
            case "Mt":
                element = "Meitnerio";
                break;
            case "Ni":
                element = "Niquel";
                break;
            case "Pd":
                element = "Paladio";
                break;
            case "Pt":
                element = "Platino";
                break;
            case "Ds":
                element = "Darmstadtio";
                break;
            case "Cu":
                element = "Cobre";
                break;
            case "Ag":
                element = "Plata";
                break;
            case "Au":
                element = "Oro";
                break;
            case "Rg":
                element = "Roentgenio";
                break;
            case "Zn":
                element = "Cinc";
                break;
            case "Cd":
                element = "Cadmio";
                break;
            case "Hg":
                element = "Mercurio";
                break;
            case "Cn":
                element = "Copernicio";
                break;
            case "B":
                element = "Boro";
                break;
            case "Al":
                element = "Aluminio";
                break;
            case "Ga":
                element = "Galio";
                break;
            case "In":
                element = "Indio";
                break;
            case "Tl":
                element = "Talio";
                break;
            case "Nh":
                element = "Nihonio";
                break;
            case "C":
                element = "Carbono";
                break;
            case "Si":
                element = "Silicio";
                break;
            case "Ge":
                element = "Germanio";
                break;
            case "Sn":
                element = "Estaño";
                break;
            case "Pb":
                element = "Plomo";
                break;
            case "Fl":
                element = "Flerovio";
                break;
            case "N":
                element = "Nitrogeno";
                break;
            case "P":
                element = "Fosforo";
                break;
            case "As":
                element = "Arsenico";
                break;
            case "Sb":
                element = "Antimonio";
                break;
            case "Bi":
                element = "Bismuto";
                break;
            case "Mc":
                element = "Moscovio";
                break;
            case "O":
                element = "Oxigeno";
                break;
            case "S":
                element = "Azufre";
                break;
            case "Se":
                element = "Selenio";
                break;
            case "Te":
                element = "Teluro";
                break;
            case "Po":
                element = "Polonio";
                break;
            case "Lv":
                element = "Livermorio";
                break;
            case "F":
                element = "Fluor";
                break;
            case "Cl":
                element = "Cloro";
                break;
            case "Br":
                element = "Bromo";
                break;
            case "I":
                element = "Yodo";
                break;
            case "At":
                element = "Astato";
                break;
            case "Ts":
                element = "Teneso";
                break;
            case "He":
                element = "Helio";
                break;
            case "Ne":
                element = "Neon";
                break;
            case "Ar":
                element = "Argon";
                break;
            case "Kr":
                element = "Kripton";
                break;
            case "Xe":
                element = "Xenon";
                break;
            case "Rn":
                element = "Radon";
                break;
            case "Og":
                element = "Oganesón";
                break;
            case "La":
                element = "Lantano";
                break;
            case "Ac":
                element = "Actinio";
                break;
            case "Ce":
                element = "Cerio";
                break;
            case "Th":
                element = "Torio";
                break;
            case "Pr":
                element = "Praseodimio";
                break;
            case "Pa":
                element = "Protactinio";
                break;
            case "Nd":
                element = "Neodimio";
                break;
            case "U":
                element = "Uranio";
                break;
            case "Pm":
                element = "Prometio";
                break;
            case "Np":
                element = "Neptunio";
                break;
            case "Sm":
                element = "Samario";
                break;
            case "Pu":
                element = "Plutonio";
                break;
            case "Eu":
                element = "Europio";
                break;
            case "Am":
                element = "Americio";
                break;
            case "Gd":
                element = "Gadolinio";
                break;
            case "Cm":
                element = "Curio";
                break;
            case "Tb":
                element = "Terbio";
                break;
            case "Bk":
                element = "Berkelio";
                break;
            case "Dy":
                element = "Disprosio";
                break;
            case "Cf":
                element = "Californio";
                break;
            case "Ho":
                element = "Holmio";
                break;
            case "Es":
                element = "Einsteinio";
                break;
            case "Er":
                element = "Erbio";
                break;
            case "Fm":
                element = "Fermio";
                break;
            case "Tm":
                element = "Tulio";
                break;
            case "Md":
                element = "Mendelevio";
                break;
            case "Yb":
                element = "Yterbio";
                break;
            case "No":
                element = "Nobelio";
                break;
            case "Lu":
                element = "Lutecio";
                break;
            case "Lr":
                element = "Lawrencio";
                break;
        }
        return element;
    }

    private void sendToWiki(String recievedText){
        String element = getElementfromSymbol(recievedText);
        String group = containsandGroup(recievedText);
        String statement = "El elemento seleccionado corresponde a "+element+" que es del grupo de "+group+".";
        tts.speak(statement,TextToSpeech.QUEUE_FLUSH,null);
        search(element);
    }

    private void checkCorrectnessOfElement(String element){
        /*for(String e : randElements){
            System.out.println(e);
        }*/
        if(randElements.contains(element)){
            correct+=1;
            randElements.remove(element);
            if(correct == numberOfElements){
                String nextQuestion = "Correcto! Muy bien jugado!";
                tts.speak(nextQuestion, TextToSpeech.QUEUE_FLUSH,null);
                Intent MainIntent = new Intent(OcrCaptureActivity.this,MainActivity.class);
                OcrCaptureActivity.this.startActivity(MainIntent);
            }else{
                String simbolo = randElements.get(0);
                String elemento = getElementfromSymbol(simbolo);
                String nextQuestion = "Correcto! Ahora, ¿qué símbolo corresponde al elemento"+elemento+"?";
                tts.speak(nextQuestion, TextToSpeech.QUEUE_FLUSH,null);
            }
        }else{
            String nextQuestion = "Incorrecto! Prueba otro símbolo.";
            tts.speak(nextQuestion, TextToSpeech.QUEUE_FLUSH,null);
        }
    }

    /**
     * onTap is called to speak the tapped TextBlock, if any, out loud.
     *
     * @param rawX - the raw position of the tap
     * @param rawY - the raw position of the tap.
     * @return true if the tap was on a TextBlock
     */
    private boolean onTap(float rawX, float rawY) {
        OcrGraphic graphic = graphicOverlay.getGraphicAtLocation(rawX, rawY);
        TextBlock text = null;
        if (graphic != null) {
            text = graphic.getTextBlock();
            if (text != null && text.getValue() != null) {
                // PERIODIC TABLE MODE
                if(ACTIVITY_MODE == 0){
                    sendToWiki(text.getValue());
                }else if(ACTIVITY_MODE == 1){
                    // Memory Mode
                    checkCorrectnessOfElement(text.getValue());
                }
            }
            else {
                Log.d(TAG, "text data is null");
            }
        }
        else {
            Log.d(TAG,"no text detected");
        }
        return text != null;
    }

    private class CaptureGestureListener extends GestureDetector.SimpleOnGestureListener {

        @Override
        public boolean onSingleTapConfirmed(MotionEvent e) {
            return onTap(e.getRawX(), e.getRawY()) || super.onSingleTapConfirmed(e);
        }
    }

    private class ScaleListener implements ScaleGestureDetector.OnScaleGestureListener {

        /**
         * Responds to scaling events for a gesture in progress.
         * Reported by pointer motion.
         *
         * @param detector The detector reporting the event - use this to
         *                 retrieve extended info about event state.
         * @return Whether or not the detector should consider this event
         * as handled. If an event was not handled, the detector
         * will continue to accumulate movement until an event is
         * handled. This can be useful if an application, for example,
         * only wants to update scaling factors if the change is
         * greater than 0.01.
         */
        @Override
        public boolean onScale(ScaleGestureDetector detector) {
            return false;
        }

        /**
         * Responds to the beginning of a scaling gesture. Reported by
         * new pointers going down.
         *
         * @param detector The detector reporting the event - use this to
         *                 retrieve extended info about event state.
         * @return Whether or not the detector should continue recognizing
         * this gesture. For example, if a gesture is beginning
         * with a focal point outside of a region where it makes
         * sense, onScaleBegin() may return false to ignore the
         * rest of the gesture.
         */
        @Override
        public boolean onScaleBegin(ScaleGestureDetector detector) {
            return true;
        }

        /**
         * Responds to the end of a scale gesture. Reported by existing
         * pointers going up.
         * <p/>
         * Once a scale has ended, {@link ScaleGestureDetector#getFocusX()}
         * and {@link ScaleGestureDetector#getFocusY()} will return focal point
         * of the pointers remaining on the screen.
         *
         * @param detector The detector reporting the event - use this to
         *                 retrieve extended info about event state.
         */
        @Override
        public void onScaleEnd(ScaleGestureDetector detector) {
            if (cameraSource != null) {
                cameraSource.doZoom(detector.getScaleFactor());
            }
        }
    }
}
