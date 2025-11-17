//
//  ContentView.swift
//  MyReminders
//
//  Created by bahar firoozbakht on 12/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \RTask.title, order: .forward) private var tasks: [RTask]

    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        Button {
                            toggle(task)
                        } label: {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                                .strikethrough(task.isCompleted)
                                .foregroundStyle(task.isCompleted ? .secondary : .primary)

                            if let date = task.dueDate {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Reminders")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddReminderView()
            }
        }
        .task {
            await NotificationManager.shared.requestAuthorization()
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let task = tasks[index]
            NotificationManager.shared.cancel(for: task)
            context.delete(task)
        }
        try? context.save()
    }

    private func toggle(_ task: RTask) {
        task.isCompleted.toggle()
        try? context.save()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: RTask.self, inMemory: true)
}
