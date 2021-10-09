/* -*- Mode: c++ -*-
 * @(#) CryptoGramTool.java 1.0 6/10/97 Ralph Morelli
 *
 * Applet: CryptoGramTool.java
 * Author: Ralph Morelli, Trinity College (ralph.morelli@trincoll.edu)
 * 
 * Copyright (c) 1996 Ralph Morelli. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for NON-COMMERCIAL purposes and
 * without fee is hereby granted provided that this copyright
 * notice appears in all copies. 
 */

import java.applet.*;
import java.awt.*;

/**
 * The main applet class for the cryptogram tool.
 * @version  1.0 6/10/97
 * @author Ralph Morelli
 */

public class CryptoGramTool extends Applet {
  public TextArea cryptoText = new TextArea (12,30);
  KeyPad keyPad;
	
  public void init() {	
    keyPad = new KeyPad(this);				// set up the keyPad canvas
    		
    setLayout( new GridLayout(2,1) );
    add(cryptoText);
    cryptoText.setBackground(Color.white);
    cryptoText.setForeground(new Color(30,30,155)) ; // (Color.blue);
    cryptoText.setFont( new Font( "Courier",0,12) );
    cryptoText.setText( initialMessage() );
    add(keyPad);
    resize(430,400);
  } // init()
    
  public boolean action (Event e, Object o ) {
    return true;
  }

  public String initialMessage( ) {
    return 	
      "                 Welcome to CRYPTOGRAM TOOL !"  +
      "\n          Replace this text with your cryptogram." + 
      "\n       Then click on the keypad below and create a key." +
      "\n         The keypad accepts letters and arrow keys." +
      "\n       Use the '*' character to reset a letter's code." +
      "\n        The keypad guards against inconsistent keys." ;
  }


  /**
   * Resets the applet.
   */
  public void reset() {
    cryptoText.setText( initialMessage() );
  }
    
  /**
   * Displays a string in the text area.
   */
  public void setDisplay( String s ) {
    cryptoText.setText(s);
  } 
  
  /**
   * Gets the text in the text area.
   */
  public String getCipherText(  ) {
    return cryptoText.getText();
  } 
  
} // CryptoGramTool class
