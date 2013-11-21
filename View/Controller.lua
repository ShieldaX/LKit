-----------------------------------------------
-- @class: Controller
-- @file Controller.lua - v0.0.1 (2013-09)
-----------------------------------------------
-- created at: 2013-09-25 10:30:13

-- ======
-- LIBRARIES
-- ======
local util = require 'util'
local class = require 'middleclass'
local View = require 'View'
--local NavigationController = require 'NavigationController'
local NavigationItem = require 'NavigationItem'

-- ======
-- CLASS
-- ======
local Controller = class 'Controller'

-- ======
-- CONSTANTS
-- ======

local ACW = display.actualContentWidth
local ACH = display.actualContentHeight
local CW = display.contentWidth
local CH = display.contentHeight
local SOX = display.screenOriginX
local SOY = display.screenOriginY

-- ======
-- VARIABLES
-- ======

-- ======
-- FUNCTIONS
-- ======

-- ------
-- Initializing a View Controller
-- ------

--- Instance constructor
-- @param opt Intent table for construct new instance.
function Controller:initialize(opt)
  assert(type(opt.title) == "string", "ERROR: title expects a string value, got "..type(opt.title))
  self.name = opt.name

  self.title = opt.title

  self.controllers = {}
  self.parentController = nil -- The container view controller this is contained in.
  self.presentedController = nil -- The view controller that is presented by this view controller.
  self.presentingController = nil -- The view controller that presented this view controller.
  self.navigationController = nil -- The nearest ancestor in the view controller hierarchy that is a navigation controller. Set by navigation contoller itself while pushing.

  -- config navigation item for navigation bar
  local navigationItem = opt.navigationItem or NavigationItem { 
    name = self.name,
    title = self.title:upper(),
    hidesBackButton = opt.hidesBackButton,
  }
  navigationItem.frame.isVisible = false
  self.navigationItem = navigationItem

  local view = nil -- base view of controller, use :view() to retrieve

  -- UI reference method
  function self:view()
    if not view then
      self:loadView()
    end
    return view
  end

  function self:isViewLoaded()
    return view ~= nil
  end

  -- implement UIs before present, override needed
  function self:loadView()
    if view then return print("View already exists") end
    view = View {
      name = self.name,
      height = ACH,
      --yOffset = display.contentCenterY,
      backgroundColor = opt.backgroundColor or {76, 217, 100},
      -- backgroundColor = {204, 204, 204, 255}, -- #ccc
    }
    
    if self.viewWillLoad then
      self:viewWillLoad(view)
    end

    if view.bounds.numChildren < 1 then
      local text = display.newText(self.title, 0, display.contentCenterY, native.systemFont, 30)
      text:setTextColor(0, 0, 0)
      view.bounds:insert(text)
      text.x = display.contentCenterX
    end

    if self.parentController then
      local superView = self.parentController:view()
      superView:addSubview(view)
      print("setup view")
    end

    if self.viewDidLoad then
      return self:viewDidLoad()
    end
  end

  function self:unloadView(saveBundle)
    --local view = self.view
    -- remove view from super controller's container view
    if view then view:removeFromSuperview() end
    view = nil
  end

  -- take view (from background) to foreground
  function self:appear()
    print(self.name, "show now!")
    if self:isViewLoaded() then
      local frame = view.frame
      frame.isVisible = true
    end
  end

  -- send view to background
  function self:disappear()
    print(self.name, "being invisible...")
    if self:isViewLoaded() then
      local frame = view.frame
      frame.isVisible = false
    end
  end

  -- stop function in memory
  function self:finalize()
    print(self.name, "finalizing...")
    if self.presentedController then
      self:dismissController()
    end
    if view then self:unloadView() end
    --TODO: nil out controller relationships
    self.parentController = nil
    self.presentedController = nil
    self.presentingController = nil
    self.navigationController = nil
  end

  -- ---
  -- Managing Child View Controllers in a Custom Container
  -- ---
  -- Add child view controller <super method>
  function self:addController(controller)
    --TODO: assert class type
    local controllers = self.controllers
    table.insert(controllers, controller)
    -- set up relationship
    controller.parentController = self
    controller.navigationController = self.navigationController
    --controller.tabController = self.tabController
  end

  function self:removeFromParentController()
    local parentController = self.parentController
    if parentController then
      local controllers = parentController.controllers
      table.remove(controllers, table.indexOf(controllers, self))
    end
    self.parentController = nil
    self.navigationController = nil
  end

  -- ---
  -- present another view controller and dismiss it
  -- ---
  function self:presentController(controller, animated)
    self.presentedController = controller -- point to presented controller
    controller.presentingController = self -- presenting controller point back to self

    local presentedView = controller:view()
    local window = self:view():getWindow()
    window:addSubview(presentedView)
    local presentedFrame = presentedView.frame
    if animated then
      transition.from(presentedFrame, {time = 400, y = ACH, transition = easing.inOutQuad}) -- ModalTransitionStyleCoverVertical
    end
  end

  function self:dismissController()
    if not self.presentedController then return end
    print("dismiss controller named", self.presentedController.name)
    local controller = self.presentedController
    local presentedView = controller:view()
    local function dismiss()
      print("finalizing controller")
      controller:finalize()
    end
    transition.to(presentedView.frame, {y = ACH, transition = easing.inOutQuad, onComplete = dismiss})
    --controller.presentingController = nil
    self.presentedController = nil
  end

  --[[ Get the nearest ancestor in the view controller hierarchy that is a navigation controller.
  function self:getNavigationController()
    local parentController = self.parentController
    while parentController do
      if Object.isInstanceOf(parentController, NavigationController) then
        return parentController
      else
        parentController = parentController.parentController
      end
    end
  end
  ]]

end

return Controller