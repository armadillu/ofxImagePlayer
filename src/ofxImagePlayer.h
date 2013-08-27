//
//  ofxImagePlayer.h
//  remoteUI_Sketch
//
//  Created by Oriol Ferrer Mesià on 21/08/13.
//
//

#ifndef __remoteUI_Sketch__ofxImagePlayer__
#define __remoteUI_Sketch__ofxImagePlayer__

#include "ofMain.h"
#include <iostream>
//#include "ofxThreadedImageLoader.h"


#define USE_NSIMAGE false /*instead of OF loader*/

class ofxImagePlayer /*: ofBaseDraws*/{

public:

	ofxImagePlayer();
	~ofxImagePlayer(){
		//loader.stopThread();
		//TODO!
	};


	bool setup(string dirPath, bool preloaded); //preloaded==true means all images will be loaded instantly
												//preloaded==false images will be loaded when needed
	void setFrameRate(float);
	void setLoops(bool);

	void start();
	void stop();
	void setFrame(int);

	void update(float dt);
	void draw(float x, float y, float w = 0.0f, float h = 0.0f);
	void drawInfo(float x, float y); //report used memory for this anim, frame index

//	float getHeight();
//	float getWidth();


private:

	ofTexture* loadImg(string path, bool useNSImage);

	bool loaded;
	float frameTime;
	float time;

	int playIndex;
	int numFrames;

	bool playing;
	bool loop;

	bool preload;

	vector<string> filenames;
	ofTexture* tex;					//for not-preloaded
	vector<ofTexture*> textures;	//for preloaded

	//ofxThreadedImageLoader loader;
	ofImage nextFrame;
	float usedMemory;
	//int w, h;
	string folderPath;
};

#endif /* defined(__remoteUI_Sketch__ofxImagePlayer__) */
