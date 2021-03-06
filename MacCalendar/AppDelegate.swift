//
//  AppDelegate.swift
//  MacCalendar
//
//  Created by bugcode on 16/7/16.
//  Copyright © 2016年 bugcode. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var settingController: SettingWindowController?
    var toolsController: ToolsWindowController?
    var calViewController:CalendarViewController?
    var statusView: StatusBarView?
    //var reminderTipController : ReminderTipWindowController?
//    let icon: IconView

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let calController = CalendarViewController()
        //calController.showWindow(self)
        self.calViewController = calController
    }
    // 窗口失去焦点的时候自动关闭
    func applicationDidResignActive(_ notification: Notification) {
        // 选中状态取消
        self.statusView!.isSelected = false
        // 窗口关闭
        self.calViewController?.window?.close()
        // 关闭时重置日期到今天
        self.calViewController?.showToday()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    func showToday() {
        self.calViewController?.showToday()
    }
    func openWindow() {

        let eventFrame = NSApp.currentEvent?.window?.frame
        let eventOrigin = eventFrame?.origin
        let eventSize = eventFrame?.size
        
        let window = calViewController?.window
        let windowFrame = window?.frame
        let windowSize = windowFrame?.size
        
        // 设置状态栏窗口的位置
        let windowTopLeftPosition = CGPoint(x: (eventOrigin?.x)! + (eventSize?.width)! / 2.0 - (windowSize?.width)! / 2.0, y: (eventOrigin?.y)! - 2)
        window?.setFrameTopLeftPoint(windowTopLeftPosition)
    
        window?.makeKeyAndOrderFront(self)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    override init()
    {
        // 加载状态栏
        let bar = NSStatusBar.system
        
        let length = NSStatusItem.variableLength
        let item = bar.statusItem(withLength: length)
        
        // 初始化状态栏图标
//        self.icon = IconView(imageName: "icon", item: item)
        self.statusView = StatusBarView.createFromNib()
        self.statusView?.initItem(imageName: "icon", item: item)
        item.view = self.statusView

        super.init()
    }
    
    // 打开设置界面
    func openSettingWindow() {
        self.settingController = SettingWindowController()
        self.settingController?.window?.makeKeyAndOrderFront(nil)
    }
    
    // 打开工具界面
    func openToolsWindow() {
        self.toolsController = ToolsWindowController()
        self.toolsController?.window?.makeKeyAndOrderFront(nil)
    }
    
    // 重新显示面板
    func refreshInterface() {
        calViewController?.showMonthPanel()
        calViewController?.setWeekendLabelColor()
    }
    

    
    override func awakeFromNib() {
        self.statusView!.onMouseDown = {
            if (self.statusView!.isSelected)
            {
                self.openWindow()
                return
            }
            self.calViewController?.window?.close()
        }
    }
}

