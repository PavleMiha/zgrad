const std = @import("std");
const testing = std.testing;

pub fn Tensor(comptime dimensions_in: []const i32) type {
    comptime var total_size_in: comptime_int = 1;
    for (dimensions_in) |x| {
        total_size_in *= x;
    }

    return struct {
        pub const dimensions = dimensions_in;
        pub const total_size = total_size_in;
        data: [total_size]f32,
        gradient: [total_size]f32,
        parent: [2]?*Tensor(dimensions),

        pub fn init() Tensor(dimensions) {
            return Tensor(dimensions){
                //initialize data to 0s

                .data = [_]f32{0} ** total_size,
                .gradient = [_]f32{0} ** total_size,
                .parent = [_]?*Tensor(dimensions){null} ** 2,
            };
        }

        pub fn add(self: @This(), b: Tensor(dimensions)) Tensor(dimensions) {
            var result: Tensor(dimensions) = Tensor(dimensions).init();
            for (self.data, 0..) |self_value, i| {
                result.data[i] = self_value + b.data[i];
            }
            return result;
        }

        pub fn mul(self: @This(), b: anytype) Tensor(dimensions) { //can I calculate the right dimensions here?
            //if (@Typ) {
            //    @compileError("Multiplying wrong type");
            //}
            var result: Tensor(dimensions) = Tensor(dimensions).init();
            for (self.data, 0..) |self_value, i| {
                result.data[i] = self_value * b.data[i];
            }
            return result;
        }
    };
}

test "multiply" {
    const A = Tensor(&.{ 8, 1 }).init();
    const B = Tensor(&.{ 1, 8 }).init();

    const C = A.mul(B);
    _ = C;
    //try testing.expect(std.meta.eql(A.mul(B), Tensor(&.{ 8, 1 }).init));
}

test "basic add functionality" {
    const A = Tensor(&.{8}).init();
    const B = Tensor(&.{8}).init();
    try testing.expect(std.meta.eql(A.add(B), Tensor(&.{8}).init()));
}
