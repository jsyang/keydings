import Cocoa;
import AVFoundation;

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var eventMonitor:Any?;
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength);
    var lastEventWasKeyDown = false;
    var currentSoundEffects = "modelM";
    
    @IBOutlet weak var menuItem_ModelM: NSMenuItem!
    @IBOutlet weak var menuItem_IOSKeys: NSMenuItem!
    @IBOutlet weak var menuItem_Typewriter: NSMenuItem!
    
    func uncheckAllItems() {
        menuItem_IOSKeys.state = NSControl.StateValue.off;
        menuItem_ModelM.state = NSControl.StateValue.off;
        menuItem_Typewriter.state = NSControl.StateValue.off;
    }
    
    @IBAction func modelMClicked(_ sender: NSMenuItem) {
        if(sender.state != NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.on;
            uncheckAllItems();
            currentSoundEffects = "modelM";
            changeSounds(soundLibraryName: currentSoundEffects);
        }
    }
    
    @IBAction func iOSKeysClicked(_ sender: NSMenuItem) {
        if(sender.state != NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.on;
            uncheckAllItems();
            currentSoundEffects = "iOSKeys";
            changeSounds(soundLibraryName: currentSoundEffects);
        }
    }
    
    @IBAction func typewriterClicked(_ sender: NSMenuItem) {
        if(sender.state != NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.on;
            uncheckAllItems();
            currentSoundEffects = "typewriter";
            changeSounds(soundLibraryName: currentSoundEffects);
        }
    }
    
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self);
    }
    
    var audioPlayer : AVAudioPlayer!;
    
    // from https://github.com/zevv/bucklespring
    let keyDown_modelM = ["01-1","02-1","03-1","04-1","05-1","06-1","07-1","08-1","09-1","0a-1","0b-1","0c-1","0d-1","0e-1","0f-1","10-1","11-1","12-1","13-1","14-1","15-1","16-1","17-1","18-1","19-1","1a-1","1b-1","1c-1","1d-1","1e-1","1f-1","20-1","21-1","22-1","23-1","24-1","25-1","26-1","27-1","28-1","29-1","2a-1","2b-1","2c-1","2d-1","2e-1","2f-1","30-1","31-1","32-1","33-1","34-1","35-1","36-1","37-1","38-1","39-1","3a-1","3b-1","3c-1","3d-1","3e-1","3f-1","40-1","41-1","42-1","43-1","44-1","45-1","46-1","47-1","48-1","49-1","4a-1","4b-1","4c-1","4d-1","4e-1","4f-1","50-1","51-1","52-1","53-1","56-1","57-1","58-1","5b-1","60-1","61-1","62-1","63-1","64-1","66-1","67-1","68-1","69-1","6a-1","6b-1","6c-1","6d-1","6e-1","6f-1","7d-1"];
    let keyUp_modelM = ["01-0","02-0","03-0","04-0","05-0","06-0","07-0","08-0","09-0","0a-0","0b-0","0c-0","0d-0","0e-0","0f-0","10-0","11-0","12-0","13-0","14-0","15-0","16-0","17-0","18-0","19-0","1a-0","1b-0","1c-0","1d-0","1e-0","1f-0","20-0","21-0","22-0","23-0","24-0","25-0","26-0","27-0","28-0","29-0","2a-0","2b-0","2c-0","2d-0","2e-0","2f-0","30-0","31-0","32-0","33-0","34-0","35-0","36-0","37-0","38-0","39-0","3a-0","3b-0","3c-0","3d-0","3e-0","3f-0","40-0","41-0","42-0","43-0","44-0","45-0","46-0","47-0","48-0","49-0","4a-0","4b-0","4c-0","4d-0","4e-0","4f-0","50-0","51-0","52-0","53-0","56-0","57-0","58-0","5b-0","60-0","61-0","62-0","63-0","64-0","66-0","67-0","68-0","69-0","6a-0","6b-0","6c-0","6d-0","6e-0","6f-0","77-0","7d-0"];
    
    // iOS key sound
    let keyDown_iOSKeys:[String] = [];
    let keyUp_iOSKeys = ["iphoneKeydown"];
    
    // typewriter key sound
    let keyDown_typewriter:[String] = [];
    let keyUp_typewriter = ["typewriter1","typewriter2"];
    
    var soundsKeyDown:[String]!;
    var soundsKeyUp:[String]!;
    
    func changeSounds(soundLibraryName:String) {
        switch(soundLibraryName) {
            case "modelM":
                soundsKeyDown = keyDown_modelM;
                soundsKeyUp = keyUp_modelM;
                break;
            case "iOSKeys":
                soundsKeyDown = keyDown_iOSKeys;
                soundsKeyUp = keyUp_iOSKeys;
                break;
            case "typewriter":
                soundsKeyDown = keyDown_typewriter;
                soundsKeyUp = keyUp_typewriter;
                break;
            default:
                break;
            
        }
    }
    
    // https://gist.github.com/cliff538/91b8f8bf818d836e1d9537081d02c580
    func playSound(soundFileName : String) {
        let soundURL = Bundle.main.url(forResource: "wav/\(soundFileName)", withExtension: "wav");
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!);
        }
        catch {
            print(error);
        }
        
        audioPlayer.play();
    }
    
    func onKeyEvent(incomingEvent:NSEvent) -> Void {
        if(audioPlayer != nil) {
            audioPlayer.stop();
        }
        
        if( (!incomingEvent.isARepeat && !lastEventWasKeyDown ) &&
            incomingEvent.type == .keyDown ||
            incomingEvent.type == .flagsChanged) {
            
            if(soundsKeyDown.count>0) {
                playSound(
                    soundFileName: soundsKeyDown[Int(arc4random_uniform(UInt32(soundsKeyDown.count)))]
                );
            }
            
            lastEventWasKeyDown = true;
            
        } else if(incomingEvent.type == .keyUp) {
            if(soundsKeyUp.count>0) {
                playSound(
                    soundFileName: soundsKeyUp[Int(arc4random_uniform(UInt32(soundsKeyUp.count)))]
                );
            }
            
            lastEventWasKeyDown = false;
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // http://footle.org/WeatherBar/
        let icon = NSImage(named: NSImage.Name(rawValue:"statusIcon"));
        icon?.isTemplate = true;
        statusItem.image = icon;
        
        //statusItem.title = "KeyDings";
        statusItem.menu = statusMenu;
        
        eventMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.keyDown , .keyUp, .flagsChanged],
            handler: onKeyEvent
        );
        
        changeSounds(soundLibraryName: "modelM");
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        NSEvent.removeMonitor(eventMonitor);
    }

}

