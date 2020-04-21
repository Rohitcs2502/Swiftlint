//
//  InteractiveHMViewController.swift
//  HeatMapComponent
//
//  Created by Rohit Kumar Agarwalla on 16/04/20.
//  Copyright © 2020 Rohit Kumar Agarwalla. All rights reserved.
//

import Cocoa
import CorePlot

class DataModel {
    var mpn: String = ""
    var soldTo: String = ""
    var deltaToTWOs: NSNumber?
}

protocol InteractiveHMDataSource {
    func valueOfXAxis() -> [Int]
}
class InteractiveHMViewController: NSWindowController {
//    var lineChartView: CPTGraphHostingView = CPTGraphHostingView(frame: NSRect(x: 20.0, y: 20.0, width: 400.0, height: 400.0))
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var scrollView: NSScrollView!
    
    var graph: CPTXYGraph!
    var interactiveHMGraph: CPTXYGraph!
    var graphDataset: [[String: Any]] = [[String: Any]]()
    var graphData = [Int: Int]()
    @IBOutlet weak var lineChartView: CPTGraphHostingView!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.calculatingDataSet()
        self.initPlot()
    }
    
    func initPlot() {
        self.configureHostView()
        self.configureGraph()
        self.configureChart()
        self.configureAxes()
    }
    
    func calculatingDataSet() {
        var xValues = self.graphDataset.filter({$0["deltaToTWOs"] as? Int != nil}).map({$0["deltaToTWOs"] as! Int})
        xValues = Array(Set(xValues))
        for eachDeltaInTwos in xValues {
            var distinctMPNs = [String]()
            for eachDict in self.graphDataset.filter({$0["deltaToTWOs"] as? Int == eachDeltaInTwos}) {
                if !distinctMPNs.contains((eachDict["mpn"] as? String)!) {
                    distinctMPNs.append(eachDict["mpn"] as! String)
                }
            }
            graphData[eachDeltaInTwos] = distinctMPNs.count
        }
    }
    func configureHostView() {
        lineChartView.allowPinchScaling = true
    }
    var lengthOfXAxis = 0
    
    func configureGraph() {
        self.graph = CPTXYGraph(frame: lineChartView.bounds)
        self.graph.apply(CPTTheme(named: CPTThemeName.plainWhiteTheme))
        graph.fill = CPTFill(color: CPTColor.clear())
        self.graph.plotAreaFrame?.plotArea?.delegate = self
        
        // Text style and graph title
        let tts = CPTMutableTextStyle()
        tts.fontSize = 14.0
        tts.color = CPTColor(nativeColor: NSColor.red)
        tts.fontName = "HelveticaNeue-Bold"
        self.graph.titleTextStyle = tts
        self.graph.title = "MPN vs Delta to TWOs"
        
        // Assigning padding to the graph view
        self.graph.paddingLeft = 40.0
        self.graph.paddingRight = 40.0
        self.graph.paddingTop = 40.0
        self.graph.paddingBottom = 60.0
        
        self.graph.plotAreaFrame?.masksToBorder = false
        lineChartView.hostedGraph = self.graph
        
        let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace
        plotSpace?.allowsUserInteraction = true
        plotSpace?.delegate = self
        
        let xValues = self.graphData.keys.sorted()
        Swift.print("X Values are \(self.graphData.keys)")
        self.lengthOfXAxis = xValues.last! - xValues.first!
        plotSpace?.xRange = CPTPlotRange(location: NSNumber(value: xValues.first!), length: NSNumber(value: self.lengthOfXAxis))
        plotSpace?.yRange = CPTPlotRange(location: NSNumber(value: 0), length: NSNumber(value: self.graphData.values.max()! + 1))
        plotSpace?.globalXRange = plotSpace?.xRange
        plotSpace?.globalYRange = plotSpace?.yRange
        
        (self.graph.axisSet as? CPTXYAxisSet)?.yAxis?.tickDirection = CPTSign.positive
        (self.graph.axisSet as? CPTXYAxisSet)?.xAxis?.tickDirection = CPTSign.negative
        
        (self.graph.axisSet as? CPTXYAxisSet)?.xAxis?.title = "Delta to TWOs"
        (self.graph.axisSet as? CPTXYAxisSet)?.yAxis?.title = "MPNs"
        (self.graph.axisSet as? CPTXYAxisSet)?.yAxis?.titleDirection = CPTSign.negative
        // Setting the axis values
        
        let dataSourceLinePlot = CPTScatterPlot()
        dataSourceLinePlot.dataSource = self
        dataSourceLinePlot.delegate = self
        dataSourceLinePlot.plotSymbolMarginForHitDetection = 5.0
        
        
        // Adding plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = CPTColor.black()
        
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill = CPTFill(color: CPTColor.blue())
        plotSymbol.lineStyle = symbolLineStyle
        plotSymbol.size = CGSize(width: 10.0, height: 10.0)
        dataSourceLinePlot.plotSymbol = plotSymbol
        
        let actualPlotStyle = dataSourceLinePlot.dataLineStyle?.mutableCopy() as? CPTMutableLineStyle
        actualPlotStyle?.lineWidth = 2.0
        actualPlotStyle?.lineColor = CPTColor(cgColor: NSColor.yellow.cgColor)
        
        dataSourceLinePlot.dataLineStyle = actualPlotStyle
        dataSourceLinePlot.interpolation = CPTScatterPlotInterpolation.linear
        
        self.graph.add(dataSourceLinePlot)
    }
    
    func configureChart() {

    }
    
    func configureAxes() {
        
    }
}

extension InteractiveHMViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.graphData.keys.count)
    }
    
    func number(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Any? {
        if fieldEnum == CPTScatterPlotField.X.rawValue {
            let xValues = self.graphData.keys.sorted()
            let key = xValues[Int(idx)]
            return key
        } else {
            let xValues = self.graphData.keys.sorted()
            let key = xValues[Int(idx)]
            Swift.print("Data is \(idx) and fieldEnum is \(fieldEnum)")
            return self.graphData[key]
        }
    }
    
//    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolTouchDownAtRecord idx: UInt) {
//        Swift.print("scatter plot shown is ind \(idx)")
//    }
//
//    func scatterPlotDataLineTouchUp(_ plot: CPTScatterPlot) {
//        Swift.print("scatterPlotDataLineTouchUp")
//    }
//
//    func scatterPlotDataLineTouchDown(_ plot: CPTScatterPlot) {
//        Swift.print("scatterPlotDataLineTouchDown")
//    }
//
//    func scatterPlotDataLineWasSelected(_ plot: CPTScatterPlot) {
//        Swift.print("scatterPlotDataLineWasSelected")
//    }
    
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt) {
        Swift.print("plotSymbolWasSelectedAtRecord")
        self.tableView.isHidden = false
        self.scrollView.isHidden = false
    }
    
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: NSEvent) {
        Swift.print("plotSymbolWasSelectedAtRecord")
    }
//    func scatterPlot(_ plot: CPTScatterPlot, dataLineTouchDownWith event: NSEvent) {
//        Swift.print("dataLineTouchDownWith \(event)")
//    }
}

extension InteractiveHMViewController: CPTPlotSpaceDelegate {
    
}
