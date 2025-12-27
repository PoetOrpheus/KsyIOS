//
//  BrandsScreen.swift
//  KsyIOS
//
//  Created by Auto on 27.12.2025.
//

import SwiftUI

struct BrandsScreen: View {
    let onBackClick: () -> Void
    
    @State private var searchQuery: String = ""
    @State private var isSelect: Bool = true // true = Магазины, false = Бренды
    
    var body: some View {
        ZStack(alignment: .top) {
            AppTheme.bgGray
                .ignoresSafeArea()
            
            TopHeaderWithSearchAndReturn(
                searchQuery: $searchQuery,
                onBackClick: onBackClick
            )
            .zIndex(1)
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: FigmaDimens.fh(100))
                
                Spacer()
                    .frame(height: FigmaDimens.fh(10))
                
                FiltersRow(
                    isSelect: isSelect,
                    onClick: {
                        isSelect.toggle()
                    }
                )
                
                ScrollView {
                    LazyVStack(spacing: FigmaDimens.fh(10)) {
                        ForEach(0..<30, id: \.self) { _ in
                            if isSelect {
                                SellerCard()
                            } else {
                                BrandsCard()
                            }
                        }
                    }
                    .padding(.horizontal, FigmaDimens.fw(10))
                    .padding(.vertical, FigmaDimens.fh(10))
                }
            }
        }
    }
}

