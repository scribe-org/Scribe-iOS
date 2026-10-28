// SPDX-License-Identifier: GPL-3.0-or-later

import Network

/// Lightweight singleton that tracks network reachability using NWPathMonitor.
final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "be.scri.networkMonitor", qos: .utility)

    private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
