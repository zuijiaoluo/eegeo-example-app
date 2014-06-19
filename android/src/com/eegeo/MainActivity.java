// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

package com.eegeo;

import android.os.Bundle;
import android.os.Handler;
import android.util.DisplayMetrics;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.app.Activity;
import android.content.res.AssetManager;

public class MainActivity extends Activity implements SurfaceHolder.Callback
{
    private EegeoSurfaceView m_surfaceView;
    private SurfaceHolder m_surfaceHolder;
    private long m_nativeAppWindowPtr;
    private boolean m_shouldUpdateNativeCode;
    
    public static native long createNativeCode(MainActivity activity, AssetManager assetManager, float dpi);
    public static native void destroyNativeCode();
    public static native void pauseNativeCode();
    public static native void resumeNativeCode();
    public static native void setNativeSurface(Surface surface);
    public static native void updateNativeCode();
    
    @Override
    public void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        System.loadLibrary("native-activity");
        
        setContentView(R.layout.activity_main);  

        m_surfaceView = (EegeoSurfaceView)findViewById(R.id.surface);
        m_surfaceView.getHolder().addCallback(this);
        
        DisplayMetrics dm = getResources().getDisplayMetrics();
		float dpi = dm.ydpi;
        
        m_nativeAppWindowPtr = createNativeCode(this, getAssets(), dpi);
        
        if(m_nativeAppWindowPtr == 0)
        {
        	throw new RuntimeException("Failed to start native code.");
        }
        
        m_shouldUpdateNativeCode = true;

        if(m_shouldUpdateNativeCode) 
        {
        	// 1 millisecond is cool because it will only repost when tick is complete
        	final int millisecondDelay = 1;
        	
            final Handler h = new Handler();
            h.postDelayed(new Runnable()
            {
                @Override
                public void run()
                {
                	if(m_nativeAppWindowPtr != 0)
                	{
                    	updateNativeCode();
                		h.postDelayed(this, millisecondDelay);
                	}
                }
            }, millisecondDelay); 
        }
    }
    
    @Override
    protected void onResume() 
    {
        super.onResume();
        resumeNativeCode();
        
        if(m_surfaceHolder != null)
        {
        	setNativeSurface(m_surfaceHolder.getSurface());
        }
    }
    
    @Override
    protected void onPause() 
    {
        pauseNativeCode();
        super.onPause();
    }

    @Override
    protected void onDestroy() 
    {
        super.onStop();
        destroyNativeCode();
        m_nativeAppWindowPtr = 0;
    }

	@Override
	protected void onPause()
	{
		pauseNativeCode();
		super.onPause();
	}

	@Override
	protected void onDestroy()
	{
		super.onStop();
		destroyNativeCode();
		m_nativeAppWindowPtr = 0;
	}

	@Override
	public void surfaceCreated(SurfaceHolder holder)
	{
		//nothing to do
	}

	@Override
	public void surfaceDestroyed(SurfaceHolder holder)
	{
		m_surfaceHolder = null;
		setNativeSurface(null);
	}

	@Override
	public void surfaceChanged(SurfaceHolder holder, int format, int width, int height)
	{
		m_surfaceHolder = holder;
		setNativeSurface(m_surfaceHolder.getSurface());
	}
}