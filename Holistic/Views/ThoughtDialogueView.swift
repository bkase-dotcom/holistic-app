import SwiftUI

struct ThoughtDialogueView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedMode: DialogueMode = .calibration
    @State private var calibrationStep: Int = 0
    @State private var isCalibrationComplete = false
    @Namespace private var modeNamespace

    enum DialogueMode: String, CaseIterable {
        case calibration = "Calibration"
        case history = "History"
    }

    private let prompts = CalibrationData.prompts
    private let conversations = ThoughtDialogueDemoData.conversations

    var body: some View {
        ZStack {
            HTheme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                modeSelector
                    .padding(.horizontal, HTheme.pagePadding)
                    .padding(.vertical, 12)

                Group {
                    switch selectedMode {
                    case .calibration:
                        calibrationView
                    case .history:
                        historyView
                    }
                }
                .transition(.opacity)
                .animation(
                    reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.4, dampingFraction: 0.8),
                    value: selectedMode
                )
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Thought Dialogue")
                    .font(HTheme.display(24))
                    .foregroundColor(HTheme.fg)
                Text("Neural bridge interface")
                    .font(HTheme.body(12))
                    .foregroundColor(HTheme.dim)
            }
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(HTheme.dim)
                    .padding(10)
            }
            .buttonStyle(.glass)
        }
        .padding(.horizontal, HTheme.pagePadding)
        .padding(.top, 16)
    }

    // MARK: - Mode Selector

    private var modeSelector: some View {
        HStack(spacing: 4) {
            ForEach(DialogueMode.allCases, id: \.rawValue) { mode in
                Text(mode.rawValue)
                    .font(HTheme.body(12, weight: .medium))
                    .foregroundColor(selectedMode == mode ? HTheme.bg : HTheme.dim)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background {
                        if selectedMode == mode {
                            Capsule()
                                .fill(HTheme.teal)
                                .matchedGeometryEffect(id: "modeBg", in: modeNamespace)
                        } else {
                            Capsule()
                                .fill(HTheme.cardBg)
                        }
                    }
                    .onTapGesture {
                        HTheme.haptic(.light)
                        withAnimation(
                            reduceMotion
                                ? .easeOut(duration: 0.2)
                                : .spring(response: 0.4, dampingFraction: 0.75)
                        ) {
                            selectedMode = mode
                        }
                    }
            }
        }
        .padding(3)
        .background(HTheme.cardBg)
        .clipShape(Capsule())
    }

    // MARK: - Calibration View

    private var calibrationView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                if isCalibrationComplete {
                    calibrationComplete
                } else {
                    // Progress
                    calibrationProgress

                    // Current prompt
                    if calibrationStep < prompts.count {
                        currentPromptCard
                            .id(calibrationStep)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }

                    // Capture button
                    captureButton

                    // Prompt list
                    promptList
                }
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 8)
            .padding(.bottom, 100)
            .animation(
                reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.5, dampingFraction: 0.8),
                value: calibrationStep
            )
        }
    }

    private var calibrationProgress: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(HTheme.teal.opacity(0.1), lineWidth: 4)
                Circle()
                    .trim(from: 0, to: CGFloat(calibrationStep) / CGFloat(prompts.count))
                    .stroke(HTheme.teal, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(
                        reduceMotion ? .easeOut(duration: 0.2) : .spring(response: 0.6, dampingFraction: 0.8),
                        value: calibrationStep
                    )

                VStack(spacing: 2) {
                    Text("\(calibrationStep)")
                        .font(HTheme.display(28))
                        .foregroundColor(HTheme.teal)
                        .contentTransition(.numericText())
                    Text("of \(prompts.count)")
                        .font(HTheme.body(10))
                        .foregroundColor(HTheme.dim)
                }
            }
            .frame(width: 80, height: 80)

            Text("NEURAL-LINGUISTIC MAPPING")
                .font(HTheme.label())
                .foregroundColor(HTheme.dim)
                .tracking(1)
        }
    }

    private var currentPromptCard: some View {
        VStack(spacing: 16) {
            let prompt = prompts[calibrationStep]

            Text(prompt.category.uppercased())
                .font(HTheme.label())
                .foregroundColor(HTheme.dim)
                .tracking(0.8)

            Text(prompt.instruction)
                .font(HTheme.body(14))
                .foregroundColor(HTheme.dim)

            Text(prompt.targetWord)
                .font(HTheme.display(42))
                .foregroundColor(HTheme.teal)
                .padding(.vertical, 8)

            WaveformView(color: HTheme.teal, amplitude: 6, frequency: 0.06, speed: 1.5, height: 24)
                .opacity(0.6)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(HTheme.teal.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.teal.opacity(0.08), lineWidth: 1)
        )
    }

    private var captureButton: some View {
        Button {
            HTheme.haptic(.medium)
            if calibrationStep < prompts.count - 1 {
                withAnimation(
                    reduceMotion
                        ? .easeOut(duration: 0.2)
                        : .spring(response: 0.4, dampingFraction: 0.75)
                ) {
                    calibrationStep += 1
                }
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isCalibrationComplete = true
                }
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 14, weight: .medium))
                Text("Signal Captured")
                    .font(HTheme.body(14, weight: .medium))
            }
            .foregroundColor(HTheme.bg)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(HTheme.teal)
            .clipShape(Capsule())
        }
    }

    private var promptList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(prompts.enumerated()), id: \.element.id) { index, prompt in
                HStack(spacing: 10) {
                    if index < calibrationStep {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(HTheme.teal)
                    } else if index == calibrationStep {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(HTheme.teal)
                    } else {
                        Image(systemName: "circle")
                            .font(.system(size: 14))
                            .foregroundColor(HTheme.dim.opacity(0.3))
                    }

                    Text(prompt.targetWord)
                        .font(HTheme.body(13, weight: index == calibrationStep ? .medium : .regular))
                        .foregroundColor(
                            index < calibrationStep ? HTheme.dim
                            : index == calibrationStep ? HTheme.fg
                            : HTheme.dim.opacity(0.4)
                        )

                    Spacer()

                    Text(prompt.category)
                        .font(HTheme.body(10))
                        .foregroundColor(HTheme.dim.opacity(0.4))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, HTheme.cardPadding)

                if index < prompts.count - 1 {
                    Divider().background(HTheme.borderColor)
                        .padding(.leading, 38)
                }
            }
        }
        .background(HTheme.cardBg)
        .clipShape(RoundedRectangle(cornerRadius: HTheme.cardRadius))
        .overlay(
            RoundedRectangle(cornerRadius: HTheme.cardRadius)
                .stroke(HTheme.borderColor, lineWidth: 1)
        )
    }

    private var calibrationComplete: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 40)

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(HTheme.teal)
                .symbolEffect(.bounce, value: isCalibrationComplete)

            Text("Calibration Complete")
                .font(HTheme.display(28))
                .foregroundColor(HTheme.fg)

            VStack(spacing: 6) {
                Text("Neural-linguistic bridge established.")
                Text("\(prompts.count) thought-patterns mapped.")
                Text("Coherence: 0.94")
            }
            .font(HTheme.body(14))
            .foregroundColor(HTheme.dim)
            .multilineTextAlignment(.center)

            WaveformView(color: HTheme.teal, amplitude: 8, frequency: 0.05, speed: 2.0, height: 32)
                .padding(.top, 12)
                .padding(.horizontal, 40)
                .opacity(0.5)

            Button {
                HTheme.haptic(.light)
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    calibrationStep = 0
                    isCalibrationComplete = false
                }
            } label: {
                Text("Recalibrate")
                    .font(HTheme.body(13, weight: .medium))
                    .foregroundColor(HTheme.dim)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(HTheme.cardBg)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
    }

    // MARK: - History View

    private var historyView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                ForEach(conversations) { conversation in
                    conversationBlock(conversation)
                }
            }
            .padding(.horizontal, HTheme.pagePadding)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }

    private func conversationBlock(_ conversation: ThoughtConversation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date header
            Text(conversation.title.uppercased())
                .font(HTheme.label())
                .foregroundColor(HTheme.dim)
                .tracking(0.8)

            // Messages
            ForEach(conversation.messages) { message in
                messageBubble(message)
            }
        }
    }

    private func messageBubble(_ message: ThoughtMessage) -> some View {
        HStack {
            if message.sender == .user { Spacer(minLength: 50) }

            VStack(alignment: message.sender == .user ? .trailing : .leading, spacing: 4) {
                HStack(spacing: 4) {
                    if message.sender == .user {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(HTheme.teal.opacity(0.6))
                    }
                    Text(message.sender.rawValue.uppercased())
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundColor(HTheme.dim.opacity(0.5))
                        .tracking(0.5)
                }

                Text(message.content)
                    .font(HTheme.body(13))
                    .foregroundColor(message.sender == .user ? HTheme.teal : HTheme.fg)
                    .lineSpacing(2)
                    .padding(12)
                    .background(
                        message.sender == .user
                            ? HTheme.teal.opacity(0.06)
                            : HTheme.cardBg
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                message.sender == .user
                                    ? HTheme.teal.opacity(0.08)
                                    : HTheme.borderColor,
                                lineWidth: 1
                            )
                    )

                Text(message.timestamp, style: .time)
                    .font(.system(size: 9, weight: .regular, design: .rounded))
                    .foregroundColor(HTheme.dim.opacity(0.4))
            }

            if message.sender == .holistic { Spacer(minLength: 50) }
        }
    }
}
