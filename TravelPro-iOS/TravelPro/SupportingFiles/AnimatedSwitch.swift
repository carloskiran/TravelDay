//
//  AnimatedSwitch.swift
//  TravelPro
//
//  Created by Mac-OBS-32 on 24/04/23.
//

import Foundation
import UIKit
public enum shapeType {
  case square
  case rounded
}
public typealias SDSwitchValueChange = (_ value: Bool) -> Void
open class BaseControl: UIControl {
  // MARK: - Property

  open var valueChange: SDSwitchValueChange?

  open var isOn: Bool = false
}

@IBDesignable public class YapSwitch: BaseControl {
  // MARK: - Properties

  //// corner radius of thumbnail in case of square
  //// It has no effect if shape is rounded
  public var thumbCornerRadius: CGFloat = 0 {
    didSet {
      layoutThumbLayer(for: layer.bounds)
    }
  }

  //// if stretch is enable .. on touch down thumbnail increase its width....
  public var isStretchEnable: Bool = true

  /// `shape` of your switch ... it can either be rounded or square .. you can set it accordingly

  public var shape: shapeType = .rounded {
    didSet {
      layoutSublayers(of: layer)
    }
  }

  /// Width of the border... it can have any `float` value
  public var borderWidth: CGFloat = 0 {
    didSet {
      trackLayer.borderWidth = borderWidth
      layoutSublayers(of: layer)
    }
  }

  public var borderColor: UIColor? {
    didSet { setBorderColor() }
  }

  public var onBorderColor: UIColor = .white {
    didSet { setBorderColor() }
  }

  public var offBorderColor: UIColor = .white {
    didSet { setBorderColor() }
  }

  public var textColor: UIColor? {
    didSet {
      (offContentLayer as? CATextLayer)?.foregroundColor = textColor?.cgColor
      (onContentLayer as? CATextLayer)?.foregroundColor = textColor?.cgColor
    }
  }

  public var onTextColor: UIColor = .white {
    didSet {
      (onContentLayer as? CATextLayer)?.foregroundColor = onTextColor.cgColor
    }
  }

  public var offTextColor: UIColor = .white {
    didSet {
      (offContentLayer as? CATextLayer)?.foregroundColor = offTextColor.cgColor
    }
  }

  public var trackTopBottomPadding: CGFloat = 0 {
    didSet {
      layoutSublayers(of: layer)
    }
  }

  public var contentLeadingTrailingPadding: CGFloat = 0 {
    didSet {
      layoutSublayers(of: layer)
    }
  }

  //// Distance of `thumb` from track layer
  public var thumbRadiusPadding: CGFloat = 3.5 {
    didSet {
      layoutThumbLayer(for: layer.bounds)
    }
  }

  public var onTintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1) {
    didSet {
      trackLayer.backgroundColor = getBackgroundColor()

      setNeedsLayout()
    }
  }

  public var offTintColor: UIColor = .white {
    didSet {
      trackLayer.backgroundColor = getBackgroundColor()
      setNeedsLayout()
    }
  }

  public var thumbTintColor: UIColor? {
    didSet { setThumbColor() }
  }

  public var onThumbTintColor: UIColor = .white {
    didSet { setThumbColor() }
  }

  public var offThumbTintColor: UIColor = .white {
    didSet { setThumbColor() }
  }

  public var onText: String? {
    didSet {
      addOnTextLayerIfNeeded()
      (onContentLayer as? CATextLayer)?.string = onText
    }
  }

  public var offText: String? {
    didSet {
      addOffTextLayerIfNeeded()
      (offContentLayer as? CATextLayer)?.string = offText
    }
  }

  public var onThumbImage: UIImage? {
    didSet {
      thumbLayer.contents = onThumbImage?.cgImage
    }
  }

  public var offThumbImage: UIImage? {
    didSet {
      thumbLayer.contents = offThumbImage?.cgImage
    }
  }

  public var thumbImage: UIImage? {
    didSet {
      thumbLayer.contents = thumbImage?.cgImage
    }
  }

  public var onImage: UIImage? {
    didSet {
      addOnImageLayerIfNeeded()
      onContentLayer?.contents = onImage?.cgImage
    }
  }

  public var offImage: UIImage? {
    didSet {
      addOffImageLayerIfNeeded()
      offContentLayer?.contents = offImage?.cgImage
    }
  }

  override public var intrinsicContentSize: CGSize {
    return CGSize(width: 52, height: 31)
  }

  // MARK: - Layers

  //// `trackLayer`:-  is main track layer
  //// `innerLayer`:- over track layer
  ////`thumLayer` :- it is used for thumb

  fileprivate lazy var trackLayer = CALayer()
  fileprivate lazy var innerLayer = CALayer()
  fileprivate lazy var thumbLayer: CALayer = {
    let layer = CALayer()
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowRadius = 2
    layer.shadowOpacity = 0.4
    layer.shadowOffset = CGSize(width: 0.75, height: 2)
    layer.contentsGravity = .resizeAspect
    return layer
  }()

  private lazy var contentsLayer = CALayer()

  private var onContentLayer: CALayer? {
    willSet {
      onContentLayer?.removeFromSuperlayer()
    }
    didSet {
      layoutOnContentLayer(for: layer.bounds)
    }
  }

  private var offContentLayer: CALayer? {
    willSet {
      offContentLayer?.removeFromSuperlayer()
    }
    didSet {
      layoutOffContentLayer(for: layer.bounds)
    }
  }

  fileprivate var isTouchDown: Bool = false

  // MARK: - initializers

  convenience init() {
    self.init(frame: .zero)
    frame.size = intrinsicContentSize
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    controlDidLoad()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    controlDidLoad()
  }

  // MARK: - Common Init

  fileprivate func controlDidLoad() {
    layer.shadowOffset = .zero
    layer.shadowOpacity = 0.3
    layer.shadowRadius = 5

    backgroundColor = .clear

    layer.addSublayer(trackLayer)
    layer.addSublayer(innerLayer)
    layer.addSublayer(contentsLayer)
    layer.addSublayer(thumbLayer)

    trackLayer.backgroundColor = getBackgroundColor()
    setBorderColor()
    trackLayer.borderWidth = borderWidth

    innerLayer.backgroundColor = UIColor.white.cgColor

    contentsLayer.masksToBounds = true

    setThumbColor()
    addTouchHandlers()
    layoutSublayers(of: layer)
  }

  // MARK: - layoutSubviews

  override public func layoutSublayers(of layer: CALayer) {
    super.layoutSublayers(of: layer)

    layoutTrackLayer(for: layer.bounds)
    layoutThumbLayer(for: layer.bounds)
    contentsLayer.frame = layer.bounds
    layoutOffContentLayer(for: layer.bounds)
    layoutOnContentLayer(for: layer.bounds)
  }

  override public func didMoveToSuperview() {
    layoutSublayers(of: layer)
  }

  fileprivate func layoutTrackLayer(for bounds: CGRect) {
    trackLayer.frame = bounds.insetBy(dx: trackTopBottomPadding, dy: trackTopBottomPadding)
    shape == .rounded ? (trackLayer.cornerRadius = trackLayer.bounds.height/2) : (trackLayer.cornerRadius = bounds.height * 0.12)
  }

  fileprivate func layoutInnerLayer(for bounds: CGRect) {
    let inset = borderWidth + trackTopBottomPadding
    let isInnerHidden = isOn || (isTouchDown && isStretchEnable)

    innerLayer.frame = isInnerHidden
      ? CGRect(origin: trackLayer.position, size: .zero)
      : bounds.insetBy(dx: inset, dy: inset)

    shape == .rounded ? (innerLayer.cornerRadius = isInnerHidden ? 0 : bounds.height/2 - inset) : (innerLayer.cornerRadius = isInnerHidden ? 5 : 5)
  }

  fileprivate func layoutThumbLayer(for bounds: CGRect) {
    let size = getThumbSize()
    let origin = getThumbOrigin(for: size.width)
    thumbLayer.frame = CGRect(origin: origin, size: size)

    if let thumb = thumbImage {
      onThumbImage = thumb
      offThumbImage = thumb
    }

    thumbLayer.contents = isOn ? onThumbImage?.cgImage : offThumbImage?.cgImage

    shape == .rounded ? (thumbLayer.cornerRadius = size.height/2) : (thumbLayer.cornerRadius = thumbCornerRadius)
  }

  private func layoutOffContentLayer(for bounds: CGRect) {
    let size = getContentLayerSize(for: offContentLayer)
    let y = bounds.midY - size.height/2
    let leading = (bounds.maxX - (contentLeadingTrailingPadding + borderWidth + getThumbSize().width))/2 - size.width/2
    let x = !isOn ? bounds.width - size.width - leading : bounds.width
    let origin = CGPoint(x: x, y: y)
    offContentLayer?.frame = CGRect(origin: origin, size: size)
    bounds.height < 50 ? ((offContentLayer as? CATextLayer)?.fontSize = 12) : ((offContentLayer as? CATextLayer)?.fontSize = bounds.height * 0.2)
  }

  private func layoutOnContentLayer(for bounds: CGRect) {
    let size = getContentLayerSize(for: onContentLayer)
    let y = bounds.midY - size.height/2
    let leading = (bounds.maxX - (contentLeadingTrailingPadding + borderWidth + getThumbSize().width))/2 - size.width/2
    let x = isOn ? leading : -bounds.width/2
    let origin = CGPoint(x: x, y: y)
    onContentLayer?.frame = CGRect(origin: origin, size: size)
    onContentLayer?.contentsCenter = CGRect(origin: origin, size: size)
    bounds.height < 50 ? ((onContentLayer as? CATextLayer)?.fontSize = 12) : ((onContentLayer as? CATextLayer)?.fontSize = bounds.height * 0.2)
  }

  fileprivate func stateDidChange() {
    trackLayer.backgroundColor = getBackgroundColor()
    trackLayer.borderWidth = borderWidth
    thumbLayer.contents = isOn ? onThumbImage?.cgImage : offThumbImage?.cgImage
    setThumbColor()
    sendActions(for: .valueChanged)
    valueChange?(isOn)
  }

  public func setOn(_ on: Bool, animated: Bool) {
    CATransaction.begin()
    CATransaction.setDisableActions(!animated)
    isOn = on
    layoutSublayers(of: layer)
    sendActions(for: .valueChanged)
    valueChange?(isOn)
    CATransaction.commit()
  }

  // MARK: - Touches

  private func addTouchHandlers() {
    addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
    addTarget(self, action: #selector(touchUp), for: [.touchUpInside])
    addTarget(self, action: #selector(touchEnded), for: [.touchDragExit, .touchCancel])

    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
    leftSwipeGesture.direction = [.left]
    addGestureRecognizer(leftSwipeGesture)

    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftRight(_:)))
    rightSwipeGesture.direction = [.right]
    addGestureRecognizer(rightSwipeGesture)
  }

  @objc
  private func swipeLeftRight(_ gesture: UISwipeGestureRecognizer) {
    let canLeftSwipe = isOn && gesture.direction == .left
    let canRightSwipe = !isOn && gesture.direction == .right
    guard canLeftSwipe || canRightSwipe else { return }
    touchUp()
  }

  @objc
   func touchDown() {
    print("touch down")
    isTouchDown = true
    layoutSublayers(of: layer)
  }

  @objc
  fileprivate func touchUp() {
    isOn.toggle()
    stateDidChange()
    touchEnded()
  }

  @objc
  fileprivate func touchEnded() {
    isTouchDown = false
    layoutSublayers(of: layer)
  }

  // MARK: - Layout Helper

  fileprivate func setBorderColor() {
    if let borderClor = borderColor {
      trackLayer.borderColor = borderClor.cgColor
    } else {
      trackLayer.borderColor = (isOn ? onBorderColor : offBorderColor).cgColor
    }
  }

  private func setThumbColor() {
    if let thumbColor = thumbTintColor {
      thumbLayer.backgroundColor = thumbColor.cgColor
    } else {
      thumbLayer.backgroundColor = (isOn ? onThumbTintColor : offThumbTintColor).cgColor
    }
  }

  final func getBackgroundColor() -> CGColor {
    return (isOn ? onTintColor : offTintColor).cgColor
  }

  fileprivate func getThumbSize() -> CGSize {
    let height = bounds.height - 2 * (borderWidth + thumbRadiusPadding)
    let width = (isTouchDown && isStretchEnable) ? height * 1.2 : height
    return CGSize(width: width, height: height)
  }

  final func getThumbOrigin(for width: CGFloat) -> CGPoint {
    let inset = borderWidth + thumbRadiusPadding
    let x = isOn ? bounds.width - width - inset : inset
    return CGPoint(x: x, y: inset)
  }

  final func getContentLayerSize(for layer: CALayer?) -> CGSize {
    let inset = 2 * (borderWidth + trackTopBottomPadding)
    let diameter = bounds.height - inset - getThumbSize().height/2
    if let textLayer = layer as? CATextLayer {
      return textLayer.preferredFrameSize()
    }
    return CGSize(width: diameter, height: diameter)
  }

  // MARK: - Content Layers

  private func addOffTextLayerIfNeeded() {
    guard offText != nil else {
      offContentLayer = nil
      return
    }
    let textLayer = CATextLayer()
    textLayer.alignmentMode = .center
    textLayer.fontSize = bounds.height * 0.2
    textLayer.font = UIFont.systemFont(ofSize: 10, weight: .bold)

    textLayer.foregroundColor = (textColor == nil) ? offTextColor.cgColor : textColor?.cgColor
    textLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(textLayer)
    offContentLayer = textLayer
  }

  private func addOnTextLayerIfNeeded() {
    guard onText != nil else {
      onContentLayer = nil
      return
    }
    let textLayer = CATextLayer()
    textLayer.alignmentMode = .center
    textLayer.fontSize = bounds.height * 0.2
    textLayer.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    textLayer.foregroundColor = (textColor == nil) ? onTextColor.cgColor : textColor?.cgColor
    textLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(textLayer)
    onContentLayer = textLayer
  }

  private func addOnImageLayerIfNeeded() {
    guard onImage != nil else {
      onContentLayer = nil
      return
    }
    let imageLayer = CALayer()
    imageLayer.contentsGravity = .center
    imageLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(imageLayer)
    onContentLayer = imageLayer
  }

  private func addOffImageLayerIfNeeded() {
    guard offImage != nil else {
      offContentLayer = nil
      return
    }
    let imageLayer = CALayer()
    imageLayer.contentsGravity = .resizeAspect
    imageLayer.contentsScale = UIScreen.main.scale
    contentsLayer.addSublayer(imageLayer)
    offContentLayer = imageLayer
  }
}
// https://dribbble.com/shots/2158763-simple-toggle
@IBDesignable public class YapSwitchSlim: YapSwitch {
  public var slimTrack: CGFloat = 0 {
    didSet {
      layoutSublayers(of: layer)
    }
  }

  override func layoutTrackLayer(for bounds: CGRect) {
    trackLayer.frame = bounds.insetBy(dx: trackTopBottomPadding, dy: trackTopBottomPadding + slimTrack)
    shape == .rounded ? (trackLayer.cornerRadius = trackLayer.bounds.height/2) : (trackLayer.cornerRadius = bounds.height * 0.2)
  }

  override func layoutInnerLayer(for bounds: CGRect) {
    let inset = borderWidth + trackTopBottomPadding
    let isInnerHidden = isOn || (isTouchDown && isStretchEnable)

    innerLayer.frame = isInnerHidden
      ? CGRect(origin: trackLayer.position, size: .zero)
      : trackLayer.frame.insetBy(dx: inset, dy: inset)

    shape == .rounded ? (innerLayer.cornerRadius = isInnerHidden ? 0 : innerLayer.bounds.height/2 - inset) : (innerLayer.cornerRadius = isInnerHidden ? 5 : 5)
  }
}
