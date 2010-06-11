//-------------------------
void initTouchPlate() {
  for (int i = 0; i < NUM_TOUCH_PLATES; i++) {
    // set the touch plate pins as inputs
    pinMode(TOUCH_PLATE_PIN_1 + 2*i + 0, INPUT);
    //pinMode(TOUCH_PLATE_PIN_1 + 2*i + 1, INPUT);
    
    // set the touch control index
    touchControls[i].set(i);
  }
}

//-------------------------
void readTouchStates() {
  for (int i = 0; i < NUM_TOUCH_PLATES; i++) {
    bitWrite(touchStates, i, digitalRead(TOUCH_PLATE_PIN_1 + 2*i + 0));
  }
}

//-------------------------
void doTouchNotes() {
  boolean state;
  int index;
  
  for (int plt = 0; plt < NUM_BUTTON_ROWS; plt++) {
    state = bitRead(touchStates, plt);
    
    if (touchControls[plt].pressed != state) {
      touchControls[plt].toggle();
      
      // trigger notes if necessary
      for (int brd = 0; brd < NUM_BUTTON_BOARDS; brd++) {
        for (int col = 0; col < NUM_BUTTON_COLS; col++) {
          index = brd*NUM_BUTTON_ROWS*NUM_BUTTON_COLS + col*NUM_BUTTON_ROWS + plt;  // plt == row
          
          // if the note is active...
          if (noteControls[index].pressed) {
            if (touchControls[plt].pressed) {
              // play the note
              noteControls[index].triggerOn();
            } else {
              // stop the note
              noteControls[index].triggerOff();
            }
          }  
        }
      }
    }
  }
}

//-------------------------
void doTouchChords() {
  boolean state;
  int index;
  
  for (int plt = 0; plt < NUM_TOUCH_PLATES; plt++) {
    state = bitRead(touchStates, plt);
    
    if (touchControls[plt].pressed != state) {
      touchControls[plt].toggle();
      
      // trigger chords if necessary
      for (int brd = 0; brd < NUM_BUTTON_BOARDS; brd++) {
        for (int col = 0; col < NUM_BUTTON_COLS; col++) {
          for (int row = 0; row < NUM_BUTTON_ROWS-1; row++) {
            index = brd*(NUM_BUTTON_ROWS-1)*NUM_BUTTON_COLS + col*(NUM_BUTTON_ROWS-1) + row;
        
            // if the chord is active...
            if (chordControls[index].pressed) {
              if (touchControls[plt].pressed) {
                // play the specific note in the chord
                chordControls[index].triggerOn(plt);  
              } else {
                // stop the specific note in the chord
                chordControls[index].triggerOff(plt);
              }
            }
          }  
        }
      }
    }
  }
}
