//
//  SwiftTestingParallelTests.swift
//  Factory
//
//  Created by Mahmood Tahir on 2025-04-16.
//

#if swift(>=6.1)
import Testing
import Factory

struct SharedContainerTrait: TestTrait, SuiteTrait, TestScoping {
    func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
        try await Container.$shared.withValue(Container()) {
            try await function()
        }
    }
}

extension Trait where Self == SharedContainerTrait {
    static var factory: Self { Self() }
}

private extension Container {
    var parallelTestDependency: Factory<Int> {
        self { 0 }
    }
}

@Suite
struct SwiftTestingParallelTests {
    @Test(.factory)
    func testWithOne() async throws {
        Container.shared.parallelTestDependency.onTest {
            1
        }

        #expect(Container.shared.parallelTestDependency() == 1)
    }

    @Test(.factory)
    func testWithTwo() async throws {
        Container.shared.parallelTestDependency.onTest {
            2
        }

        #expect(Container.shared.parallelTestDependency() == 2)
    }

    @Test(.factory)
    func testWithThree() async throws {
        Container.shared.parallelTestDependency.onTest {
            3
        }

        #expect(Container.shared.parallelTestDependency() == 3)
    }
}
#endif
