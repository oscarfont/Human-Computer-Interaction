package com.google.android.gms.samples.vision.ocrreader.ui.camera;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.google.android.gms.samples.vision.ocrreader.OcrCaptureActivity;
import com.google.android.gms.samples.vision.ocrreader.R;

public class MainActivity extends AppCompatActivity {

    private Button periodicTable;
    private Button memory;
    private Button formulas;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        periodicTable =  findViewById(R.id.tableButton);
        periodicTable.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // your handler code here
                Intent CameraIntent = new Intent(MainActivity.this, OcrCaptureActivity.class);
                CameraIntent.putExtra("ACTIVITY_MODE", 0); //Optional parameters
                MainActivity.this.startActivity(CameraIntent);
            }
        });
        memory =  findViewById(R.id.memoryButton);
        memory.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // your handler code here
                Intent CameraIntent = new Intent(MainActivity.this, OcrCaptureActivity.class);
                CameraIntent.putExtra("ACTIVITY_MODE", 1); //Optional parameters
                MainActivity.this.startActivity(CameraIntent);
            }
        });
        formulas =  findViewById(R.id.fromulaButton);
        formulas.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                // your handler code here
                Intent FormulaIntent = new Intent(MainActivity.this, FormulaActivity.class);
                MainActivity.this.startActivity(FormulaIntent);
            }
        });
    }
}
