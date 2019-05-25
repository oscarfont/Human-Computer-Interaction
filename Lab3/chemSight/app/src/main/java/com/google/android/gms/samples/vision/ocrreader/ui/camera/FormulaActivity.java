package com.google.android.gms.samples.vision.ocrreader.ui.camera;

import android.speech.tts.TextToSpeech;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.google.android.gms.samples.vision.ocrreader.R;

import org.w3c.dom.Text;

import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FormulaActivity extends AppCompatActivity {

    // Text to speech
    private TextToSpeech tts;
    private Button validate;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_formula);

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
        tts = new TextToSpeech(this, listener);

        validate =  findViewById(R.id.validateButton);
        validate.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // your handler code here
                TextView part1Box = findViewById(R.id.part1);
                TextView part2Box = findViewById(R.id.part2);
                String part1 = part1Box.getText().toString();
                String part2 = part2Box.getText().toString();
                if(part1.isEmpty() || part2.isEmpty()){
                    TextView result = findViewById(R.id.result);
                    String statement = "¡No puedo evaluar una fórmula vacía!\nInserta texto en ambas casillas por favor.";
                    result.setText(statement);
                    tts.speak(statement, TextToSpeech.QUEUE_FLUSH,null);
                }else{
                    String formula = part1 + "->" + part2;
                    checkCorrectnessOfFormula(formula);
                }
            }
        });
    }

    private int calculateCount(String eqPart) {
        Matcher matcher = Pattern.compile("(\\d*) ([A-Z]\\w*)").matcher(eqPart);
        int totalCount = 0;
        while (matcher.find()) {
            String moleculeCountStr = matcher.group(1);
            int moleculeCount = moleculeCountStr.isEmpty() ? 1 : Integer.parseInt(moleculeCountStr);
            String molecule = matcher.group(2);
            Matcher moleculeMatcher = Pattern.compile("[A-Z][a-z]*(\\d*)").matcher(molecule);
            while (moleculeMatcher.find()) {
                String atomCountStr = moleculeMatcher.group(1);
                int atomCount = atomCountStr.isEmpty() ? 1 : Integer.parseInt(atomCountStr);
                totalCount += moleculeCount * atomCount;
            }
        }
        return totalCount;
    }

    private void checkCorrectnessOfFormula(String formula){
        System.out.println(formula);
        String[] partsOfFormula = formula.split("->");
        int firstPart = 0;
        int secondPart = 0;
        firstPart = calculateCount(partsOfFormula[0]);
        secondPart = calculateCount(partsOfFormula[1]);
        String statement = "";
        System.out.println(firstPart);
        System.out.println(secondPart);
        TextView result = findViewById(R.id.result);
        if(firstPart == secondPart){
            statement = "¡Tu reacción está correctamente balanceada!";
        }else{
            statement = "Revisa tu formula porqué no está correctamente balanceada.";
        }
        String moleculas = "Moleculas parte 1: "+String.valueOf(firstPart)+"\nMoleculas parte 2: "+String.valueOf(secondPart);
        result.setText(statement+"\n"+moleculas);
        tts.speak(statement, TextToSpeech.QUEUE_FLUSH,null);
    }

}
