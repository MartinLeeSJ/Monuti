//
//  TargetListCell.swift
//  GongdeunTop
//
//  Created by Martin on 2023/05/15.
//

import SwiftUI

struct TargetListCell: View {
    @EnvironmentObject var themeManager: ThemeManager
    let target: Target
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 5) {
                Text("단기")
                    .font(.caption)
                    .padding(3)
                    .background(themeManager.getColorInPriority(of: .weak))
                Spacer()
                Text("23/05/14")
                    .font(.caption)
                    .fixedSize()
                    .padding(4)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                
                Text("23/05/16")
                    .font(.caption)
                    .fixedSize()
                    .padding(4)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
            }
            
            HAlignment(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("TargetTitle")
                        .font(.headline)
                    Text("TargetSubTitle")
                        .font(.subheadline)
                }
            }
            Divider()
            
            Grid(verticalSpacing: 10) {
                GridRow {
                    Text("성취도")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize()
                    
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                    
                    Text("해낸 일들")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize()
                    
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal, .vertical])
                    
                    Text("남은 일수")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize()
                    
                }
                
                GridRow {
                    
                    RoundedHexagon(radius: 16, cornerAngle: 5)
                        .frame(width: 35)
                    
                    Divider()
                        .frame(width: 25)
                        .rotationEffect(Angle(degrees: 90))
                    
                    Text("0")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    
                    Divider()
                        .frame(width: 25)
                        .rotationEffect(Angle(degrees: 90))
                    
                    Text("D-3")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                        .fixedSize()
                    
                    
                }
                .frame(height: 35)
            }
            
        }
        .padding()
        .background(.white, in: RoundedRectangle(cornerRadius: 10))
        
    }
}

struct TargetListCell_Previews: PreviewProvider {
    static var previews: some View {
        TargetListCell(target: .placeholder)
    }
}
