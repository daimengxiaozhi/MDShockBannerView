package com.youth.banner.view;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.ImageView;

import java.lang.ref.WeakReference;


public class RoundAngleImageView extends ImageView {

    private Paint paint;

    private Paint paint2;
    private WeakReference<Bitmap> mWeakBitmap;

    private float round = 0;
    private boolean leftOrRight = false;

    public RoundAngleImageView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        init(context, attrs);
    }

    public RoundAngleImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context, attrs);
    }

    public RoundAngleImageView(Context context) {
        super(context);
        init(context, null);
    }

    private void init(Context context, AttributeSet attrs) {
        paint = new Paint();
        paint.setColor(Color.WHITE);
        paint.setAntiAlias(true);
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.DST_OUT));
        paint2 = new Paint();
        paint2.setXfermode(null);
    }


    @Override
    protected void onDraw(Canvas canvas) {

        Bitmap bitmap = mWeakBitmap == null ? null : mWeakBitmap.get();

        if (null == bitmap || bitmap.isRecycled()) {
            //拿到Drawable
            Drawable drawable = getDrawable();


            if (drawable != null) {
                //创建bitmap
                bitmap = Bitmap.createBitmap(getWidth(), getHeight(),
                        Bitmap.Config.ARGB_8888);

                //创建画布
                Canvas drawCanvas = new Canvas(bitmap);
                super.onDraw(drawCanvas);
                drawCircle(drawCanvas);
                //将准备好的bitmap绘制出来
                canvas.drawBitmap(bitmap, 0, 0, paint2);

                //bitmap缓存起来，避免每次调用onDraw，分配内存
                mWeakBitmap = new WeakReference<Bitmap>(bitmap);
            }
        }
        //如果bitmap还存在，则直接绘制即可
        if (bitmap != null) {
            Canvas drawCanvas = new Canvas(bitmap);
            super.onDraw(drawCanvas);
            drawCircle(drawCanvas);
            //将准备好的bitmap绘制出来
            canvas.drawBitmap(bitmap, 0, 0, paint2);

        }

    }

    private void drawCircle(Canvas canvas) {
        Path path = new Path();
        if (leftOrRight) {
            path.addCircle(0, getHeight() / 2, round * getWidth() * 1.1f, Path.Direction.CW);
        } else {
            path.addCircle(getWidth(), getHeight() / 2, round * getWidth() * 1.1f, Path.Direction.CW);
        }
        canvas.drawPath(path, paint);
    }

    public void setRound(float round) {
        this.round = round;
        invalidate();
    }

    public void setLeftOrRight(boolean leftOrRight) {
        this.leftOrRight = leftOrRight;
    }

    @Override
    public void invalidate() {
        mWeakBitmap = null;
        super.invalidate();
    }
}
