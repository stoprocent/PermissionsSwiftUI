//
//  ModalView.swift
//
//
//  Created by Jevon Mao on 1/30/21.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
struct ModalView: View {
    @EnvironmentObject var store: PermissionStore
    @EnvironmentObject var schemaStore: PermissionSchemaStore
    @StateObject private var carouselStore = CarouselStore()

    @Binding var showModal: Bool
    var mainText: MainTexts{store.mainTexts.contentChanged ? store.mainTexts : store.configStore.mainTexts}

    var body: some View {
        ScrollView {
            VStack { 
                HeaderView(exitButtonAction: {showModal = schemaStore.shouldStayInPresentation}, mainText: mainText)
                    
                PermissionSection(showing: $showModal)
                    .background(store.configStore.backgroundColors.modalCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
                    .frame(maxWidth:UIScreen.main.bounds.width-30)

                // Show continue button if carousel flow is enabled
                if store.configStore.enableCarouselFlow {
                    ContinueButtonSection(showing: $showModal)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                }

                Text(.init(mainText.bottomDescription))
                    .font(.system(.callout, design: .rounded))
                    .foregroundColor(Color(.systemGray))
                    .padding(.horizontal)
                    .textHorizontalAlign(.leading)
                    .padding(.top, store.configStore.enableCarouselFlow ? 10 : 0)

                Spacer()
            }
            .padding(.bottom,30)

        }
        .background(store.configStore.backgroundColors.modalBackground)
        .preferredColorScheme(store.configStore.colorSchemeOverride)
        .edgesIgnoringSafeArea(.all)
        .introspectViewController{
            if store.configStore.restrictDismissal ||
                store.restrictAlertDismissal ||
                store.restrictModalDismissal {
                $0.isModalInPresentation = true
            }
        }
        .environmentObject(carouselStore)
        .onAppear {
            // Initialize carousel store with dependencies
            if store.configStore.enableCarouselFlow {
                carouselStore.initialize(
                    permissionStore: store,
                    schemaStore: schemaStore,
                    showing: $showModal
                )
            }
        }
    }
}
