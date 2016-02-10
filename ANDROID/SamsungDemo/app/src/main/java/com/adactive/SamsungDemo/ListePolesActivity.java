package com.adactive.SamsungDemo;

import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.ScaleDrawable;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;



public class ListePolesActivity extends AppCompatActivity {

    public static final int RESULT_OK = 10101;

    Button bu1, bu2, bu3, bu4;

    void Go(long poiId) {
        Bundle conData = new Bundle();
        conData.putLong("poiId", poiId);
        Intent intent = new Intent();
        intent.putExtras(conData);
        setResult(RESULT_OK, intent);
        finish();
    }

    void SetupButton(String title, int drawableId, Button b)
    {
        Drawable drawable = getResources().getDrawable(drawableId);
        //int h = drawable.getIntrinsicHeight();
        //int w = drawable.getIntrinsicWidth();
        drawable.setBounds( 0, 0, 96, 96 );
        b.setCompoundDrawables(drawable, null, null, null);

        b.setText(title);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_liste_poles);

        bu1 = (Button)findViewById(R.id.buPole1);
        bu2 = (Button)findViewById(R.id.buPole2);
        bu3 = (Button)findViewById(R.id.buPole3);
        bu4 = (Button)findViewById(R.id.buPole4);

        bu1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Go(102101);
            }
        });
        bu2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Go(102102);
            }
        });
        bu3.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Go(102105);
            }
        });
        bu4.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Go(102106);
            }
        });


        SetupButton("Espace Retail", R.drawable.ic_2843444bb5e0ac8272dce54f229ae8f5c635763c, bu1);
        SetupButton("Espace WorkSpace", R.drawable.ic_5b4a86343de5240f934a40ed87e39bcaa55816af, bu2);
        SetupButton("Espace Hospitality", R.drawable.ic_ba652f4a0794ba5b76088581c1f2975a58712bfd, bu3);
        SetupButton("Espace Santé", R.drawable.ic_5796908a3dc4e6826e4ec33dbce210e95190e3c8, bu4);
    }

}
