package com.youth.banner;

/**
 * 作者：HQY on 18/4/24 10:39
 * 邮箱：hqy_xz@126.com
 */

public class BannerEntity {

    private String bg;
    private String img;


    public String getBg() {
        return bg == null ? "" : bg;
    }

    public void setBg(String bg) {
        this.bg = bg;
    }

    public String getImg() {
        return img == null ? "" : img;
    }

    public void setImg(String img) {
        this.img = img;
    }
}
