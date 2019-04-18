import processing.sound.*;
import java.util.HashMap;

public class SoundManager{
    // Attributes
    private HashMap<String,SoundFile> sounds;
    private boolean playedOnce;

    // Constructor
    SoundManager(){
      sounds = new HashMap<String,SoundFile>();
      playedOnce = true;
    }

    // Add Sound
    public void addSound(String name, SoundFile file){
      sounds.put(name, file);
    }

    // Play Sound
    public void playSound(String name){
      if(playedOnce){
        SoundFile sound = sounds.get(name);
        sound.play();
        playedOnce = false;
      }
    }
    
    // Stop Sound
    public void stopSound(){
      playedOnce = true;
    }

}
