#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){

	ofBackground(255);
	ofSetFrameRate(60);
	ofSetVerticalSync(true);

	//PNG_PRELOAD makes a BIG Difference performance-wise
	// true >> preloads all images at setup, playback is very fast but takes lots of vram
	//false >> images are loaded when requested, quite slow depending on image size!

	anim.setup("plops", true/*PNG_PRELOAD*/);
	anim.setFrameRate(30);
	anim.setLoops(true);
	anim.start();

	anim2.setup("plops2", false/*PNG_PRELOAD*/);
	anim2.setFrameRate(30);
	anim2.setLoops(true);
	anim2.start();

}

//--------------------------------------------------------------
void testApp::update(){

	anim.update(1/60.);
	anim2.update(1/60.);
}

//--------------------------------------------------------------
void testApp::draw(){

	anim.draw(100, 100);
	anim2.draw(200, 100);

	ofxImagePlayer::drawInfo(10, 10); //show mem stats
}

