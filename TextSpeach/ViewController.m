//
//  ViewController.m
//  TextSpeach
//
//  Created by 本田忠嗣 on 2016/05/02.
//  Copyright © 2016年 TadatsuguHonda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController() <NSSpeechSynthesizerDelegate, NSTableViewDataSource, NSTableViewDelegate>
{
	NSSpeechSynthesizer *_speechSynth;
	NSArray *_voices;
}
@property (weak) IBOutlet NSTextFieldCell *text;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *speakButton;
@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Do any additional setup after loading the view.
	_speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
	[_speechSynth setDelegate:self];
	_voices = [NSSpeechSynthesizer availableVoices];
	
	[self.text setStringValue:@"ここに喋らせたい言葉を入れてね"];
	[self.stopButton setEnabled:NO];
	
	NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
	NSInteger defaultRow =[_voices indexOfObject:defaultVoice];
	NSIndexSet *indices = [NSIndexSet indexSetWithIndex:defaultRow];
	[_tableView selectRowIndexes:indices byExtendingSelection:NO];
	[_tableView scrollRowToVisible:defaultRow];
}

- (void)viewWillAppear {
	[super viewWillAppear];

	NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
	NSInteger defaultRow =[_voices indexOfObject:defaultVoice];
	[_tableView scrollRowToVisible:defaultRow];

}
//ViewController viewDidAppear

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender didFinishSpeaking:(BOOL)finishedSpeaking
{
	NSLog(@"finsihed speaking");
	
	[self.speakButton setEnabled:YES];
	[self.stopButton setEnabled:NO];
	[_tableView setEnabled:YES];
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];

	// Update the view, if already loaded.
}

- (IBAction)sayIt:(id)sender {
	NSString* string = [self.text stringValue];
	if (string.length <=0) {
		return;
	}
	[_speechSynth startSpeakingString:string];
	
	[self.speakButton setEnabled:NO];
	[self.stopButton setEnabled:YES];
	[_tableView setEnabled:NO];
}

- (IBAction)stopIt:(id)sender {
	[_speechSynth stopSpeaking];
}

// NSTableView の NSTableViewDataSource デリゲート
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return _voices.count;
}

// NSTableView の NSTableViewDataSource デリゲート
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	NSString *v=[_voices objectAtIndex:row];
	NSDictionary *dict=[NSSpeechSynthesizer attributesForVoice:v];
	return [dict objectForKey:NSVoiceName];
}

// NSTableViewDelegate のデリゲート
// （選択した時にCallされる）
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
	NSInteger row = [_tableView selectedRow];
	if (row == -1) {
		return;
	}
	
	NSString *selectedVoice = [_voices objectAtIndex:row];
	[_speechSynth setVoice:selectedVoice];
}

@end
