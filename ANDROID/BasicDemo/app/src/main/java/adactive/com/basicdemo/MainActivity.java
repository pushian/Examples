package adactive.com.basicdemo;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.LinearLayout;

import com.adactive.nativeapi.AdActiveEventListener;
import com.adactive.nativeapi.CheckForUpdatesNotice;
import com.adactive.nativeapi.MapView;

public class MainActivity extends AppCompatActivity {

    private MapView map;
    private AdActiveEventListener adActiveEventListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        map = new MapView(this);
        //Add the MapView to the main layout
        LinearLayout container = (LinearLayout) findViewById(R.id.map_container);
        container.addView(map);
        //Create an AdactiveEventListner which listens to events sent by the MapView
        adActiveEventListener = new AdActiveEventListener() {
            @Override
            public void OnPOIClickedHandler(int[] ints, int i) {
            }
            @Override
            public void OnBuildingClickedHandler(int i) {
            }
            @Override
            public void OnFloorChangedHandler(int i) {
            }
            @Override
            public void OnFloorClickedHandler(int i) {
            }
            @Override
            public void OnTextClickedHandler(int[] ints, int i) {
            }
            @Override
            public void OnMapLoadedHandler() {
            }
            @Override
            public void OnAdActiveViewStartHandler(int i) {
            }
            @Override
            public void OnCheckForUpdatesHandler(int i) {
                //When update finished load the map
                if (i == CheckForUpdatesNotice.CHECKFORUPDATES_UPDATESFOUND || i == CheckForUpdatesNotice.CHECKFORUPDATES_UPDATESNOTFOUND) {
                    map.start();
                }
            }
        };
        //Register the EventListener
        map.addEventListener(adActiveEventListener);
        //Set the camera mode
        map.setCameraMode(MapView.CameraMode.FULL);

        //Start the Update
        map.update();

        //If Data is already available Load the map
        if(map.isMapDataAvailable())
            map.start();
    }

    @Override
    protected void onDestroy() {
        map.destroy();
        super.onDestroy();
    }

    @Override
    protected void onPause() {
        map.onPause();
        super.onPause();
    }

    @Override
    protected void onResume() {
        map.onResume();
        super.onResume();
    }
}
