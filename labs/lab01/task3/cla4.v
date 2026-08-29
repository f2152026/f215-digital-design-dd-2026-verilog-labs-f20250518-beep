// cla4.v
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor #(2) #(2) + one and #(2) per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and #(2)/or #(2)
// primitives accept mor #(2)e than 2 inputs directly, e.g.:
//   and #(2) #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;
  wire c00, c10, c11, c20, c21, c22, c30, c31, c32, c33;

  // TODO: your gate-level P/G, carry, and #(2) sum logic goes here.
  xor #(2) (p0, a[0], b[0]);
  and #(2) (g0, a[0], b[0]);

  xor #(2) (p1, a[1], b[1]);
  and #(2) (g1, a[1], b[1]);

  xor #(2) (p2, a[2], b[2]);
  and #(2) (g2, a[2], b[2]);

  xor #(2) (p3, a[3], b[3]);
  and #(2) (g3, a[3], b[3]);

  and #(2) (c00, p0, cin);
  or #(2) (c1, g0, c00);
  xor #(2) (sum[0], cin, p0);

  and #(2) (c10, p1, g0);
  and #(2) (c11, p1, p0, cin);
  or #(2) (c2, g1, c10, c11);
  xor #(2) (sum[1], c1, p1);

  and #(2) (c20, p2, g1);
  and #(2) (c21, p2, p1, g0);
  and #(2) (c22, p2, p1, p0, cin);
  or #(2) (c3, g2, c20, c21, c22);
  xor #(2) (sum[2], c2, p2);

  and #(2) (c30, p3, g2);
  and #(2) (c31, p3, p2, g1);
  and #(2) (c32, p3, p2, p1, g0);
  and #(2) (c33, p3, p2, p1, p0, cin);
  or #(2) (cout, g3, c30, c31, c32, c33);
  xor #(2) (sum[3], c3, p3);
  // (cout should be connected to c4.) Remember the delay on every gate.

endmodule
