//
//  MessageThreadView.swift
//  Amare
//
//  Created by Micheal Bingham on 5/30/22.
//

import SwiftUI
import FirebaseAuth

struct MessageThreadView: View {
	
	@Binding var thread: MessageThread
	
	//MARK: - Only for testing in preview
 /// Helps preview understand if this is a sent or received messsage, should be nil in production
	var me_for_testing: AmareUser? = AmareUser(id: UUID().uuidString, name: "Bob")
	/// Helps preview understand if this is a sent or received messsage, should be nil in production
	var them_for_testing: AmareUser? = AmareUser(id: UUID().uuidString, name: "Bob")
	var test_mode: Bool = false
	
	@State var beginProfilePicAnimation: Bool = false
	
	@State var animationSpeed: SpeedOfAnimation = .slow
	
	
	//TODO: - Group messages
	var thumbNail: String? {
		
		guard !test_mode else {
			// in test mode
			if thread.type == .twoWay {
				
				return them_for_testing?.profile_image_url
				
			} else {
				//TODO: group messages
				return nil
			}
		}
		if thread.type != .twoWay {
			return thread.thumbnailURL
		} else {
			
			// return the user that is NOT me
			return thread.otherUser?.profile_image_url
		}
	}
	
    var body: some View {
		HStack {
			/*
							ZStack {
								readIndicator
									.frame(width: 11, height: 11)
								Image(item.unreadIndicator)
							}
			*/

			
			if test_mode{
				Background(style: .creative)
					.clipShape(Circle())
					.frame(width: 10, height: 10)
					// only show if I read. or if in test mode if i read
					//.opacity(test_mode ? (thread.lastMessage?.readBy.contains(me_for_testing!) ? 0: 1): 0)
			} else {
				
				var me = AmareUser(id: Auth.auth().currentUser?.uid ?? "")
				
				Background(style: .creative)
					.clipShape(Circle())
					.frame(width: 10, height: 10)
					.opacity(thread.lastMessage?.readBy.first(where: {$0.id == me.id}) != nil ? 0: 1)
			}
			
				
			
			ProfileImageView(profile_image_url: thumbNail, size: CGFloat(55))
				.scaleEffect(beginProfilePicAnimation ? 0.9 : 1)
				.onChange(of: animationSpeed, perform: { newValue in
					print("Animation speed did change .. \(newValue)")
					beginProfilePicAnimation = false
					var speed = 0.0
			
					switch newValue {
					case .slow:
						speed = 2
					case .normal:
						speed = 1
					case .medium:
						speed = 0.5
					case .fast:
						speed = 0.1
					}
				
					
					DispatchQueue.main.async {
						
						print("Setting speed to ... \(speed) ")
						withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
							beginProfilePicAnimation = true
						}
					}
					
				})
				.onChange(of: thread.lastMessage) { lastMessage in
					print("Did change last message .. \(thread.lastMessage)")
					guard lastMessage != nil else { return }
					
					guard !test_mode else {
						
						guard lastMessage != nil else  { return }
						if !lastMessage!.readBy.contains(me_for_testing!){
							animationSpeed = .fast
						} else { animationSpeed = .slow  }
						
						return
					}
					
					if !lastMessage!.hasRead {
						// i haven't read the message
						animationSpeed = .fast
					} else {
						animationSpeed = .slow
					}
				
				}
				.onAppear {
					beginProfilePicAnimation = false
					var speed = 0.0
					var lastMessage = thread.lastMessage
					guard !test_mode else {
						
						guard lastMessage != nil else  { return }
						if !lastMessage!.readBy.contains(me_for_testing!){
							animationSpeed = .fast
						} else { animationSpeed = .slow  }
						
						return
					}
					
					if !lastMessage!.hasRead {
						// i haven't read the message
						animationSpeed = .fast
					} else {
						animationSpeed = .slow
					}
					
					DispatchQueue.main.async {
						
						
						withAnimation(.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
							beginProfilePicAnimation = true
						}
					}
				}
					//.padding()
				
				//.border(.white)
			
		
							VStack(alignment: .leading){
								HStack{
									//Text("\(!test_mode ? (thread.otherUser?.name ?? "No name") : them_for_testing!.name!)")
									Text("\((thread.otherUser?.name ?? "No name"))")
										.font(.headline).bold()
										.lineLimit(1)

									Spacer()

									Text("\(thread.lastModified.timeStampForMessages())")
										.font(.caption)
										.foregroundColor(.secondary)

									Image(systemName: "chevron.forward")
										.font(.caption)
										.foregroundColor(.secondary)
								}
								.padding(.bottom, 0.5)

								Text("\(thread.lastMessage?.text ?? "")")
									.font(.subheadline)
									.lineLimit(3)
									.foregroundColor(.secondary)
									//.padding([.top, .bottom], 0.5)
									//.padding(.top, 1)
							}
						}
    }
}

struct MessageThreadView_Previews: PreviewProvider {
    static var previews: some View {
		var me = AmareUser.random()
		var them = AmareUser.random()
		
		var thread = MessageThread.randomThread(with: me, and: them)
	
		MessageThreadView(thread: .constant(thread), me_for_testing: me, them_for_testing: them, test_mode: true)
			.onAppear(perform: {
				//thread.lastMessage = Message.random(with: me, and: them)
			})
			.onTapGesture {
				 /*me = AmareUser.random()
				them = AmareUser.random()
				thread.lastMessage = Message.random(with: me, and: them)
				  */
			}
			.preferredColorScheme(.dark)
    }
}

extension Date {
	func timeStampForMessages() -> String {
		let formatter = DateFormatter()
		
		// same day, no need to show date, just time
		if self.day() == Date().day() {
			formatter.timeStyle = .short
		} else {
			// Not same date, no need to show time
			formatter.dateStyle = .short
		}
		
		
		
		return formatter.string(from: self)
	}
}
