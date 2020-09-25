source 'https://github.com/CocoaPods/Specs.git'
  
platform :ios, '13.0'
inhibit_all_warnings!

workspace 'Tasks'

def shared_pods
  
  use_frameworks!
  
end

def tasks_sdk_pods
  
  use_frameworks!
  
end

target 'Tasks' do
  project 'Tasks.xcodeproj'
  shared_pods
end

target 'TasksSDK' do
    project 'TasksSDK/TasksSDK.xcodeproj'
    tasks_sdk_pods
end
